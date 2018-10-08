json.assigned_users @assigned_users do |a|
  json.partial! 'users/userlist', user: a
end
json.unassigned_users @unassigned_users do |u|
  json.partial! 'users/userlist', user: u
end
json.roles @roles