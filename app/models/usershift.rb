class Usershift < ApplicationRecord
    belongs_to :user
    belongs_to :shift

    validates :user, uniqueness: { scope: :shift_id }
end
