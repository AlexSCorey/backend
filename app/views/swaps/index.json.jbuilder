json.swaps @swaps do |swap|
  json.id swap.id
  json.requesting_user_id swap.requesting_user_id
  json.requesting_user_name swap.requesting_user.name
  json.shift_id swap.shift_id
  json.shift_start_time swap.shift.start_time
  json.shift_end_time swap.shift.end_time
  json.calendar_id swap.shift.calendar.id
  json.calendar_name swap.shift.calendar.name
end