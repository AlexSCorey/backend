class AvailabilityResponsesController < ApplicationController

  def show
    @request = current_request
    render "/availability_responses/show.json", status: :ok
  end

  def update
  end

  private

  def current_request
    authenticate_with_http_token do |token, options|
      return  AvailabilityRequest.find_by_api_token(token)
    end
  end

end
