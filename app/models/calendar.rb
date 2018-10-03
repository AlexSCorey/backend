class Calendar < ApplicationRecord
  validates :name, presence: true
  validate :time_zone_exists

  has_many :roles
  has_many :users, through: :roles do
    def owners
        where("roles.role = 'owner'", true)
    end
    def managers
        where("roles.role = 'manager'", true)
    end
    def employees
        where("roles.role = 'employee'", true)
    end
  end


  private

  def time_zone_exists
    return if ActiveSupport::TimeZone[time_zone].present?
    errors.add(:time_zone, "does not match rails time zone string")
  end

end
