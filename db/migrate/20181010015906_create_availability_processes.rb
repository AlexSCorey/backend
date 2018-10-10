class CreateAvailabilityProcesses < ActiveRecord::Migration[5.2]
  def change
    create_table :availability_processes do |t|
      t.belongs_to :calendar, index: true
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end

    remove_column :availability_requests, :start_date, :datetime
    remove_column :availability_requests, :end_date, :datetime
    add_reference :availability_requests, :availability_process
  end
end
