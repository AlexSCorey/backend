# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

USERS = [
  {name: "Greg Taylor",
    email: "greguser@doesnotexist.com",
    password: "gregpassword",
    phone_number: "123-456-7890"
  },
  {name: "Sohel Patel",
    email: "soheluser@doesnotexist.com",
    password: "sohelpassword",
    phone_number: "123-456-7890"
  },
  {name: "Alex Corey",
    email: "alexuser@doesnotexist.com",
    password: "alexpassword",
    phone_number: "123-456-7890"
  },
  {name: "Michael Bond",
    email: "mikeuser@doesnotexist.com",
    password: "mikepassword",
    phone_number: "123-456-7890"
  },
]

USERS.each do |user|
  User.create!(user)
end

CALENDARS = [
  {name: "Chief Beef's Burger Stop",
    employee_hour_threshold_daily: 10,
    employee_hour_threshold_weekly: 40,
    time_zone: "Eastern Time (US & Canada)",
    daylight_savings: true},
  {name: "Monsieur Frites Fry Salon",
    employee_hour_threshold_daily: 6,
    employee_hour_threshold_weekly: 30,
    time_zone: "Central Time (US & Canada)",
    daylight_savings: true},
  {name: "Momento Polaroid Archive",
    employee_hour_threshold_daily: 16,
    employee_hour_threshold_weekly: 60,
    time_zone: "Mountain Time (US & Canada)",
    daylight_savings: true},
  {name: "Bigly Smiles Dentist",
    employee_hour_threshold_daily: 8,
    employee_hour_threshold_weekly: 50,
    time_zone: "Pacific Time (US & Canada)",
    daylight_savings: true}
]

CALENDARS.each do |calendar_source|
  users = User.all.shuffle()
  calendar = Calendar.create!(calendar_source)
  Role.add(users.first, calendar, "owner")
  2.times {Role.add(users.shift, calendar, "manager")}
  users.each{|u| Role.add(u, calendar, "employee")}
end

NOTE_TEXT = [
  "there is going to be a parade on this day, watch out for crowds",
  "I'll be on vacation in Hawaii on this day",
  "there will be construction on the street this day, it might be slow",
  "I'm expecting a large delivery on this day",
  "watch for an internet technition around 3pm on this day",
  "I may have to leave early on this day",
  "I've got a great feeling about this day",
  "this is my birthday!",
  "please schedule me for as many hours as possible on this day",
  "I'm probably going to be late on this day"
]

Calendar.all.each do |calendar|
  users = calendar.users
  date_index = Date.today - 100
  200.times do
    Random.rand(4).times do
      Note.new(
        user_id: users.sample.id,
        calendar_id: calendar.id,
        text: NOTE_TEXT.sample,
        date: date_index
      ).save
    end
    date_index += 1
  end
end