json.availability_requests @requests do |request|
  json.partial! 'availability_requests/request_li', request: request
end