json.id swap.id
json.requesting_user do
  if swap.requesting_user
    json.id swap.requesting_user.id
    json.name swap.requesting_user.name
  end
end
json.accepting_user do
  if swap.accepting_user
    json.id swap.accepting_user.id
    json.name swap.accepting_user.name
  end
end
json.shift do
  if swap.shift
    json.id swap.shift.id
    json.start_time swap.shift.start_time
    json.end_time swap.shift.end_time
    json.calendar do
      json.id swap.shift.calendar.id
      json.name swap.shift.calendar.name
    end
  end
end