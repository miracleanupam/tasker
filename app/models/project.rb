class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  accepts_nested_attributes_for :tasks

  validates :name, presence: true, length: { maximum: 100 }

  def task_feed
    tasks.all
  end
end
