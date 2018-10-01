class CreateCalendars < ActiveRecord::Migration[5.2]
  def change
    create_table :calendars do |t|
      t.string :name
      t.float :employee_hour_threshold_daily
      t.float :employee_hour_threshold_weekly

      t.timestamps
    end
  end
end
