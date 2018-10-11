class User < ApplicationRecord

    has_secure_password
    has_secure_token :api_token
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: {minimum: 5}, allow_nil: true
    validates :name, presence: true

    has_many :usershifts
    has_many :shifts, through: :usershifts

    has_many :roles
    has_one :invitation

    has_many :calendars, through: :roles do
        def owned
            where("roles.role = 'owner'", true)
        end
        def managed
            where("roles.role = 'manager'", true)
        end
        def employed
            where("roles.role = 'employee'", true)
        end
    end
    has_many :notes

    has_many :requested_swaps, class_name: "Swap", foreign_key: :requesting_user
    has_many :accepted_swaps, class_name: "Swap", foreign_key: :accepting_user

    def generate_password_token!
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
        save!
    end

    def password_token_valid?
        (self.reset_password_sent_at + 2.hours) > Time.now.utc
    end

    def reset_password!(password)
        self.reset_password_token = nil
        self.password = password
        save!
    end

    def conflicting_shifts(input_shift)
        self.shifts.where("shifts.start_time <= ? AND shifts.end_time > ?",
            input_shift.start_time, input_shift.start_time).or(
                self.shifts.where("shifts.start_time > ? AND shifts.start_time < ?",
                    input_shift.start_time, input_shift.end_time)
            )
    end

    def shift_time_in_availability_process(process)
        duration = 0
        shifts = process.shifts.merge(self.shifts)
        shifts.each {|shift| duration += shift.duration}
        return duration
    end

    private

    def generate_token
        SecureRandom.hex(10)
    end
end
