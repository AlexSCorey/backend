class Role < ApplicationRecord
  belongs_to :user
  belongs_to :calendar

  validates :user_id, presence: true
  validates :calendar_id, presence: true
  validates :role, presence: true

  def self.add(user, calendar, type)
    Role.new(user_id: user.id,
      calendar_id: calendar.id,
      role: type).save!
  end

end
