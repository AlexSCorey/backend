class Shift < ApplicationRecord
    has_many :users, through: :user_shifts
    belongs_to :calendar

end
