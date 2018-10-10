class AddStartAndEndDatesToAvailabilityRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :availability_requests, :start_date, :datetime
    add_column :availability_requests, :end_date, :datetime
  end
end
