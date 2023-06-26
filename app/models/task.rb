class Task < ApplicationRecord
  belongs_to :project

  validates :description, presence: true
  enum :status, { to_do: 0, ongoing: 1, completed: 2, failed: 3, rejected: 4 }
end
