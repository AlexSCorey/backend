class Calendar < ApplicationRecord
  validates :name, presence: true
  validate :time_zone_exists

  has_many :roles
  has_many :users, through: :roles do
    def owners
        where("roles.role = 'owner'", true)
    end
    def managers
        where("roles.role = 'manager'", true)
    end
    def employees
        where("roles.role = 'employee'", true)
    end
  end
  has_many :notes
  has_many :shifts
  has_many :swaps, through: :shifts

  def sql_summary_query(start_date, end_date)
    # this query should be rewritten to sanitize inputs
    sql = %Q|SELECT
date_trunc('day', shifts.start_time) AS "Day",
COUNT(shifts.id) AS "total_shifts",
SUM(shifts.capacity) AS "total_capacity",
SUM(usershift_query.usershift_count) AS "total_assigned_capacity",
COUNT(shifts.id) FILTER (WHERE published=true) AS "published_shifts",
SUM(shifts.capacity) FILTER (WHERE published=true) AS "published_capacity",
SUM(usershift_query.usershift_count) FILTER (WHERE published=true) AS "pulished_assigned_capacity",
COUNT(shifts.id) FILTER (WHERE published=false) AS "unpublished_shifts",
SUM(shifts.capacity) FILTER (WHERE published=false) AS "unpublished_capacity",
SUM(usershift_query.usershift_count) FILTER (WHERE published=false) AS "unpulished_assigned_capacity"
FROM shifts
LEFT JOIN
(SELECT usershifts.shift_id,
COUNT (usershifts.id) AS "usershift_count"
FROM usershifts
GROUP BY usershifts.shift_id) AS "usershift_query"
ON (shifts.id = usershift_query.shift_id)
WHERE shifts.calendar_id=| + self.id.to_s + %Q|
AND date_trunc('day', shifts.start_time) BETWEEN '| +
start_date + %Q|' AND '| + end_date + %Q|'
GROUP BY 1 
ORDER BY 1|
    return ActiveRecord::Base.connection.execute(sql)
  end

  def alerts_daily(date)
    response = {date: date, alerts: {
      employee_hours_alerts: [],
      unassigned_shift_capacity: {}
    }}
    self.users.distinct.each do |user|
      hours = 0
      user.shifts.where(calendar_id: self.id).each do |shift|
        hours += shift.duration_during(date.to_date.beginning_of_day,
          date.to_date.end_of_day)/3600
      end
      if hours > self.employee_hour_threshold_daily
        response[:alerts][:employee_hours_alerts].push({
          user: {
            id: user.id,
            name: user.name},
          hours: hours})
      end
    end
    return response
  end

  private

  def time_zone_exists
    return if ActiveSupport::TimeZone[time_zone].present?
    errors.add(:time_zone, "does not match rails time zone string")
  end

end
