class AvailabilityResponsesController < ApplicationController

  def show
    @request = current_request
    render "/availability_responses/show.json", status: :ok
  end

  def update
    @request = current_request
    @response_inputs = params[:responses]
    update_responses(@request, @response_inputs)
    render "/availability_responses/show.json", status: :ok
  end

  private

  def current_request
    authenticate_with_http_token do |token, options|
      return  AvailabilityRequest.find_by_api_token(token)
    end
  end

  def update_responses(request, response_inputs)
    AvailabilityResponse.transaction do
      request.availability_responses.each do |response|
        if response_inputs.key?(response.id.to_s)
          response.available = response_inputs[response.id.to_s]
          response.save!
        end
      end
      request.complete = true
      request.save!
    end
  end

end
