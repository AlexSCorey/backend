class Role < ApplicationRecord
  belongs_to :user
  belongs_to :calendar

  validates :user_id, presence: true
  validates :calendar_id, presence: true
  validates :role, presence: true
  validates :role, inclusion: { in: %w(owner manager employee),
    message: "%{value} is not a valid role" }
  validates :role, uniqueness: { scope: [:user_id, :calendar_id] }

  def self.add(user, calendar, type)
    Role.new(user_id: user.id,
      calendar_id: calendar.id,
      role: type).save!
  end

end
