class Invitation < ApplicationRecord
  has_secure_token :api_token
  belongs_to :user
end
