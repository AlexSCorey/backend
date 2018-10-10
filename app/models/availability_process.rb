class AvailabilityProcess < ApplicationRecord
  belongs_to :calendar
  has_many :availability_requests
end
