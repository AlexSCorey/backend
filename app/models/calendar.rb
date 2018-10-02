class Calendar < ApplicationRecord
  validates :name, presence: true
  validate :time_zone_exists

  has_and_belongs_to_many :owners,
    class_name: "User",
    join_table: "calendars_owners"
  has_and_belongs_to_many :managers,
    class_name: "User",
    join_table: "calendars_managers"
  has_and_belongs_to_many :employees,
    class_name: "User",
    join_table: "calendars_employees"


  private

  def time_zone_exists
    return if ActiveSupport::TimeZone[time_zone].present?
    errors.add(:time_zone, "does not match rails time zone string")
  end

end
