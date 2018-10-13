class AvailabilityProcess < ApplicationRecord
  belongs_to :calendar
  has_many :availability_requests, dependent: :destroy
  has_many :availability_responses, through: :availability_requests
  has_many :availability_process_shifts, dependent: :destroy
  has_many :shifts, through: :availability_process_shifts

  def assign_shifts
    shifts = self.shifts.to_a
    usershifts = []
    while shifts.length > 0
      shifts.reject!{|shift| shift.unconflicted_available_users.count == 0}
      shifts.reject!{|shift| shift.users.count >= shift.capacity}
      if shifts.any?
        shifts.sort_by!{|shift| shift.unconflicted_available_users.count}
        shift = shifts.first
        user = shift.unconflicted_available_users.first
        usershift = Usershift.new(user_id: user.id, shift_id: shift.id)
        usershift.save!
        usershifts.push(usershift)
      end
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

end
