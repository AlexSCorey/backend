json.employees @calendar.users.employees do |e|
    json.partial! 'users/userlist', user: e
end
json.managers @calendar.users.managers do |m|
    json.partial! 'users/userlist', user: m
end
json.owners @calendar.users.owners do |o|
    json.partial! 'users/userlist', user: o
end