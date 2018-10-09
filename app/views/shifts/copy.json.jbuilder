json.shift @past_shifts do |past_shift|
    json.id past_shift.id
    json.start_time past_shift.start_time
    json.end_time past_shift.end_time
    json.calendar_id past_shift.calendar_id
    json.published past_shift.published
    json.capacity past_shift.capacity
    json.username @shift.users do |user|
        json.username user.name
    end
end
