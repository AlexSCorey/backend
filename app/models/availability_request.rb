class AvailabilityRequest < ApplicationRecord
  has_secure_token :api_token
  belongs_to :user
  belongs_to :calendar
  belongs_to :availability_process
  has_many :availability_responses
end
