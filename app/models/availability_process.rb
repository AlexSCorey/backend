class AvailabilityProcess < ApplicationRecord
  belongs_to :calendar
  has_many :availability_requests, dependent: :destroy
  has_many :availability_responses, through: :availability_requests
  has_many :availability_process_shifts, dependent: :destroy
  has_many :shifts, through: :availability_process_shifts

  def assign_shifts
    shifts = self.viable_shifts_by_unconflicted_available_users
    usershifts = []
    while shifts.length > 0
      shift = shifts.first
      user = shift.unconflicted_available_users.first
      usershift = Usershift.new(user_id: user.id, shift_id: shift.id)
      usershift.save!
      usershifts.push(usershift)
      shifts = self.viable_shifts_by_unconflicted_available_users
    end
    self.destroy
    return usershifts
  end

  def self.seed(calendar_id, start_date, end_date, chance)

    process = AvailabilityProcess.new(
      calendar_id: calendar_id,
      start_date: start_date,
      end_date: end_date)
    process.save!

    shifts = Shift.where(
      calendar_id: process.calendar.id,
      start_time: start_date.beginning_of_day .. end_date.end_of_day)
    shifts.each do |shift|
      AvailabilityProcessShift.new(
        availability_process_id: process.id,
        shift_id: shift.id
      ).save!
    end

    process.calendar.users.distinct.each do |user|
      request = AvailabilityRequest.new(
        user_id: user.id,
        availability_process_id: process.id,
        complete: true)
      request.save!

      process.shifts.each do |shift|
        response = AvailabilityResponse.new(
          availability_request_id: request.id,
          shift_id: shift.id,
          available: (rand() < chance))
        response.save!
      end
    end

    return process
  end

  def shifts_by_unconflicted_available_users
    pgsql = %Q|SELECT
    s.*,
    (SELECT 
        COUNT(u.*)
    FROM
        users u, 
        availability_responses res, 
        availability_requests req, 
        availability_processes ap,
        availability_process_shifts aps2,
        shifts s2
    WHERE
        u.id = req.user_id AND
        res.availability_request_id = req.id AND
        res.shift_id = s2.id AND
        req.availability_process_id = ap.id AND
        ap.id = aps2.availability_process_id AND
        s2.id = aps2.shift_id AND
        res.available = TRUE AND
        s2.id = s.id AND
        (SELECT COUNT(*) FROM users u2, usershifts us, shifts s3
         WHERE u2.id = us.user_id AND
             s3.id = us.shift_id AND
             u2.id = u.id AND
             ((s3.start_time <= s2.start_time AND s3.end_time > s2.start_time) OR
             (s3.start_time > s2.start_time AND s3.start_time < s2.end_time))) = 0) AS unconflicted_available_users
FROM
    shifts s,
    availability_process_shifts aps
WHERE
    s.id = aps.shift_id AND
    aps.availability_process_id = | + self.id.to_s + %Q|
ORDER BY unconflicted_available_users ASC|

    Shift.find_by_sql(pgsql)
  end

  def viable_shifts_by_unconflicted_available_users
    pgsql = %Q|SELECT
    s.*,
    (SELECT 
        COUNT(u.*)
    FROM
        users u, 
        availability_responses res, 
        availability_requests req, 
        availability_processes ap,
        availability_process_shifts aps2,
        shifts s2
    WHERE
        u.id = req.user_id AND
        res.availability_request_id = req.id AND
        res.shift_id = s2.id AND
        req.availability_process_id = ap.id AND
        ap.id = aps2.availability_process_id AND
        s2.id = aps2.shift_id AND
        res.available = TRUE AND
        s2.id = s.id AND
        (SELECT COUNT(*) FROM users u2, usershifts us, shifts s3
         WHERE u2.id = us.user_id AND
             s3.id = us.shift_id AND
             u2.id = u.id AND
             ((s3.start_time <= s2.start_time AND s3.end_time > s2.start_time) OR
             (s3.start_time > s2.start_time AND s3.start_time < s2.end_time))) = 0) AS unconflicted_available_users
FROM
    shifts s,
    availability_process_shifts aps
WHERE
    s.id = aps.shift_id AND
    aps.availability_process_id = | + self.id.to_s + %Q| AND
    (SELECT 
            COUNT(u.*)
        FROM
            users u, 
            availability_responses res, 
            availability_requests req, 
            availability_processes ap,
            availability_process_shifts aps2,
            shifts s2
        WHERE
            u.id = req.user_id AND
            res.availability_request_id = req.id AND
            res.shift_id = s2.id AND
            req.availability_process_id = ap.id AND
            ap.id = aps2.availability_process_id AND
            s2.id = aps2.shift_id AND
            res.available = TRUE AND
            s2.id = s.id AND
            (SELECT COUNT(*) FROM users u2, usershifts us, shifts s3
             WHERE u2.id = us.user_id AND
                 s3.id = us.shift_id AND
                 u2.id = u.id AND
                 ((s3.start_time <= s2.start_time AND s3.end_time > s2.start_time) OR
                 (s3.start_time > s2.start_time AND s3.start_time < s2.end_time))) = 0) > 0 AND
            (SELECT COUNT(us4.*)
                 FROM usershifts us4
                 WHERE us4.shift_id = s.id) < s.capacity
ORDER BY unconflicted_available_users ASC|

    Shift.find_by_sql(pgsql)
  end

end
