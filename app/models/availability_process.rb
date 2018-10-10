class AvailabilityProcess < ApplicationRecord
  belongs_to :calendar
  has_many :availability_requests
  has_many :availability_responses, through: :availability_requests
end
