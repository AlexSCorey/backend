class Swap < ApplicationRecord
  has_secure_token :api_token
  belongs_to :shift
  belongs_to :requesting_user, class_name: "User"
  belongs_to :accepting_user, class_name: "User", optional: true
end
