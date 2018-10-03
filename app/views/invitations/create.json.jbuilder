json.invitation do
  json.user_id @user.id
  json.email @user.email
  json.calendar_id @calendar.id
  json.calendar_name @calendar.name
  json.role @role.role
end