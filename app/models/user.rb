class User < ApplicationRecord

    has_secure_password
    has_secure_token :api_token
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: {minimum: 5}
    validates :name, presence: true

    has_and_belongs_to_many :owned_calendars,
        class_name: "Calendar",
        join_table: "calendars_owners"
    has_and_belongs_to_many :managed_calendars,
        class_name: "Calendar",
        join_table: "calendars_managers"
    has_and_belongs_to_many :employed_calendars,
        class_name: "Calendar",
        join_table: "calendars_employees"
end
