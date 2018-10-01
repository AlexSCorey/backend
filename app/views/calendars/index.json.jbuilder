json.owned_calendars @owned_calendars do |c|
  json.partial! 'calendars/calendar_li', calendar: c
end
json.managed_calendars @managed_calendars do |c|
  json.partial! 'calendars/calendar_li', calendar: c
end
json.employed_calendars @employed_calendars do |c|
  json.partial! 'calendars/calendar_li', calendar: c
end