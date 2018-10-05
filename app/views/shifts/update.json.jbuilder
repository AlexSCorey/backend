json.shift do
    json.id @shift.id
    json.start_time @shift.start_time
    json.end_time @shift.end_time
    json.calendar_id @shift.calendar_id
    json.published @shift.published
    json.capacity @shift.capacity
end