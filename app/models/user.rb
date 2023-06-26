class User < ApplicationRecord
  attr_accessor :reset_token, :activation_token

  has_secure_password
  has_many :projects, dependent: :destroy

  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 250 }, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def project_feed
    if admin?
      Project.all
    else
      projects.all
    end
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def create_activation_digest
    self.activation_token = User.new_token
    update_column(:activation_digest, User.digest(activation_token))
  end

  def send_reset_email
    UserMailer.password_reset(self).deliver
  end

  def send_activation_email
    UserMailer.activation(self).deliver
  end

  def authenticated?(token)
    return false if activation_digest.nil? || activation_digest.blank?

    BCrypt::Password.new(activation_digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  private

  def downcase_email
    email.downcase!
  end
end
