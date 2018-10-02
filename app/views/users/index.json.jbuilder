json.employees @calendar.employees do |e|
    json.partial! 'users/userlist', user: e
end
json.managers @calendar.managers do |m|
    json.partial! 'users/userlist', user: m
end
json.owners @calendar.owners do |o|
    json.partial! 'users/userlist', user: o
end