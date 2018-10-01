class CreateUsersCalendarAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :calendars_owners do |t|
      t.belongs_to :calendar, index: true
      t.belongs_to :user, index: true
    end
    create_table :calendars_managers do |t|
      t.belongs_to :calendar, index: true
      t.belongs_to :user, index: true
    end
    create_table :calendars_employees do |t|
      t.belongs_to :calendar, index: true
      t.belongs_to :user, index: true
    end
  end
end
