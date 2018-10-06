class Shift < ApplicationRecord
    has_many :usershifts
    has_many :users, through: :usershifts
    belongs_to :calendar

    validate   :capacity_greater_than_zero, :end_time_greater_than_start_time


    private

    def capacity_greater_than_zero
        if capacity < 1
            errors.add(:capacity, "Must be greater than 0.")
        end
    end

    def end_time_greater_than_start_time
        if start_time > end_time
            errors.add( :start_time, "Must be earlier than shift end time!")
        end
    end
    




end
