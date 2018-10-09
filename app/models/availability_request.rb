class AvailabilityRequest < ApplicationRecord
  has_secure_token :api_token
  belongs_to :user
  belongs_to :calendar
end
