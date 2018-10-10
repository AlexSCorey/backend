class AvailabilityProcess < ApplicationRecord
  belongs_to :calendar
  has_many :availability_requests, dependent: :destroy
  has_many :availability_responses, through: :availability_requests

  def self.seed(calendar_id, start_date, end_date, chance)
    process = AvailabilityProcess.new(calendar_id: calendar_id,
      start_date: start_date,
      end_date: end_date)
    process.save!

    process.calendar.users.distinct.each do |user|
      request = AvailabilityRequest.new(
        user_id: user.id,
        availability_process_id: process.id,
        complete: true)
      request.save!

      shifts = Shift.where(
        calendar_id: calendar_id,
        start_time: start_date.beginning_of_day .. end_date.end_of_day)

      shifts.each do |shift|
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
