class AvailabilityProcessesController < ApplicationController

  def create
    @user = current_user
    @calendar = Calendar.find(params[:calendar_id])
    Time.zone = @calendar.time_zone
    @roles = @user.roles.where(calendar_id: @calendar.id).map{|r| r.role}
    if @roles.include?("manager") || @roles.include?("owner")
      if params[:start_date] && params[:end_date]
        start_date = Time.zone.parse(params["start_date"])
        end_date = Time.zone.parse(params["end_date"])
        generate_availability_objects(@calendar, start_date, end_date)
      else
        render json: {error: "start_date and end_date are required"}, status: :unauthorized
      end
    else
      render json: nil, status: :unauthorized
    end
  end

  def assign_shifts
    @user = current_user
    @calendar = Calendar.find(params[:calendar_id])
    @roles = @user.roles.where(calendar_id: @calendar.id).map{|r| r.role}
    if @roles.include?("manager") || @roles.include?("owner")
      AvailabilityProcess.find(params[:availability_process_id]).assign_shifts
      render json: nil, status: :ok
    else
      render json: nil, status: :unauthorized
    end
  end

  private

  def generate_availability_objects(calendar, start_date, end_date)
    begin
      requests = []
      AvailabilityRequest.transaction do

        process = AvailabilityProcess.new(
          calendar_id: calendar.id,
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

        calendar.users.distinct.each do |user|
          availability_request = AvailabilityRequest.new(
            user_id: user.id,
            availability_process_id: process.id,
            complete: false)
          availability_request.save!

          process.shifts.each do |shift|
            availability_response = AvailabilityResponse.new(
              availability_request_id: availability_request.id,
              shift_id: shift.id,
              available: false)
            availability_response.save!
          end
        end

        send_availability_request_emails(process)
      end
    rescue => error
      render json: {error: error.message}, status: :unprocessable_entity
    end
  end

  def send_availability_request_emails(process)
    @process = process
    @process.availability_requests.each do |request|
      UserMailer.with(request: request).availability_request_email.deliver_now
    end
    render "/availability_processes/create.json", status: :ok
  end

end
