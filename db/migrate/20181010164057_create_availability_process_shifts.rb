class CreateAvailabilityProcessShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :availability_process_shifts do |t|
      t.belongs_to :availability_process, index: true
      t.belongs_to :shift, index: true
      t.timestamps
    end
  end
end
