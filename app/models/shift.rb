class Shift < ApplicationRecord
    has_many :usershifts
    has_many :users, through: :usershifts
    has_many :swaps
    has_many :availability_responses
    has_many :availability_requests, through: :availability_responses
    has_many :availability_users, through: :availability_requests, source: :user
        
    belongs_to :calendar

    validate   :capacity_greater_than_zero, :end_time_greater_than_start_time 

    def duration
        self.end_time - self.start_time
    end

    def duration_during(start_time, end_time)
        if self.start_time < start_time
            if self.end_time < start_time
                0
            elsif self.end_time > end_time
                end_time - start_time
            else
                self.end_time - start_time
            end
        elsif self.start_time > end_time
            0
        else
            if self.end_time < end_time
                self.end_time - self.start_time
            else
                end_time - self.start_time
            end
        end
    end

    def available_users
        self.availability_users.merge(
            AvailabilityResponse.where(available: true))
    end

    def unconflicted_available_users
        pgsql = %Q|SELECT 
        u.*,
        COALESCE((SELECT SUM(s3.end_time - s3.start_time) FROM shifts s3, usershifts us2 WHERE s3.id = us2.shift_id AND us2.user_id = u.id AND s3.id IN (SELECT aps2.shift_id FROM availability_process_shifts aps2 WHERE aps2.availability_process_id = ap.id)), INTERVAL '0 hours') AS hours 
    FROM 
       users u, 
       availability_responses res, 
       availability_requests req, 
       availability_processes ap,
       availability_process_shifts aps,
       shifts s
    WHERE u.id = req.user_id AND
          res.availability_request_id = req.id AND
          res.shift_id = s.id AND
          req.availability_process_id = ap.id AND
          ap.id = aps.availability_process_id AND
          s.id = aps.shift_id AND
          res.available = 't' AND
          s.id = | + self.id.to_s + %Q| AND
          (SELECT COUNT(*) FROM users u2, usershifts us, shifts s2
           WHERE u2.id = us.user_id AND
                 s2.id = us.shift_id AND
                 u2.id = u.id AND
                 ((s2.start_time <= s.start_time AND s2.end_time > s.start_time) OR
                 (s2.start_time > s.start_time AND s2.start_time < s.end_time))) = 0
    ORDER BY hours DESC|
        User.find_by_sql(pgsql)
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
