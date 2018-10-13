json.shifts @shifts do |shift|
  json.shift_id shift.id
  json.start_time shift.start_time
  json.end_time shift.end_time
  json.calendar_name shift.calendar.name
end