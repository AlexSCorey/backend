json.role @role
json.id @calendar.id
json.name @calendar.name
json.time_zone @calendar.time_zone
json.daylight_savings @calendar.daylight_savings
if @role == "owner" || @role == "manager"
  json.employee_hour_threshold_daily @calendar.employee_hour_threshold_daily
  json.employee_hour_threshold_weekly @calendar.employee_hour_threshold_weekly
  json.updated_at @calendar.updated_at
  json.created_at @calendar.created_at
end