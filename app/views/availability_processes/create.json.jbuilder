json.availability_process do
  json.id @process.id
  json.calendar_id @process.calendar_id
  json.calendar_name @process.calendar.name
  json.start_date @process.start_date
  json.end_date @process.end_date
  json.availability_requests @process.availability_requests do |request|
    json.partial! 'availability_processes/request_li', request: request
  end
end