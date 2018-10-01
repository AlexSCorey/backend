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