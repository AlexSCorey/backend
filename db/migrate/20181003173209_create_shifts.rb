class CreateShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :shifts do |t|
      t.datetime "start_time"
      t.datetime "end_time"
      t.belongs_to :calendar, index: true
      t.integer "capacity"
  
      t.timestamps
    end
  end
end
