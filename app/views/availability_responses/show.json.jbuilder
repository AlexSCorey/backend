json.availability_process do
  json.id @request.availability_process.id
  json.calendar_id @request.availability_process.calendar_id
  json.calendar_name @request.availability_process.calendar.name
  json.start_date @request.availability_process.start_date
  json.end_date @request.availability_process.end_date
  json.request do
    json.id @request.id
    json.user_id @request.user_id
    json.user_name @request.user.name
    json.responses @request.availability_responses do |response|
      json.partial! 'availability_responses/response_li', response: response
    end
  end
end