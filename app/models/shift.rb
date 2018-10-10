class Shift < ApplicationRecord
    has_many :usershifts
    has_many :users, through: :usershifts
    has_many :swaps
    has_many :availability_responses
    has_many :availability_requests, through: :availability_responses
    has_many :availability_users, through: :availability_requests, source: :user
        
    belongs_to :calendar

    validate   :capacity_greater_than_zero, :end_time_greater_than_start_time 

    def duration_during(start_time, end_time)
        if self.start_time.to_time < start_time.to_time
            if self.end_time.to_time < start_time.to_time
                0
            elsif self.end_time.to_time > end_time.to_time
                end_time.to_time - start_time.to_time
            else
                self.end_time.to_time - start_time.to_time
            end
        elsif self.start_time.to_time > end_time.to_time
            0
        else
            if self.end_time.to_time < end_time.to_time
                self.end_time.to_time - self.start_time.to_time
            else
                end_time.to_time - self.start_time.to_time
            end
        end
    end

    def available_users
        self.availability_users.merge(
            AvailabilityResponse.where(available: true))
    end

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
