class AddTimeZoneAndDaylightSavingsToCalendars < ActiveRecord::Migration[5.2]
  
  def change

    change_table :calendars do |t|
      t.string :time_zone
      t.boolean :daylight_savings
    end

  end
end
