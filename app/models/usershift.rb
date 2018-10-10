class Usershift < ApplicationRecord
    belongs_to :user
    belongs_to :shift

    validates :user, uniqueness: { scope: [:user_id, :shift_id] }
end
