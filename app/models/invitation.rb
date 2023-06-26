class Invitation < ApplicationRecord
  attr_accessor :invite_token

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def is_valid?(token)
    return false if token.blank? || token.nil?

    BCrypt::Password.new(send('invite_digest')).is_password?(token)
  end

  def create_invite_digest
    self.invite_token = Invitation.new_token
    update_column(:invite_digest, Invitation.digest(invite_token))
  end

  def send_invite_email(invitee)
    UserMailer.invitation(self, invitee).deliver_now
  end
end
