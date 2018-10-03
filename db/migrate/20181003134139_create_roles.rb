class CreateRoles < ActiveRecord::Migration[5.2]
  def change

    drop_table :calendars_owners
    drop_table :calendars_managers
    drop_table :calendars_employees

    create_table :roles do |t|
      t.belongs_to :user, index: true
      t.belongs_to :calendar, index: true
      t.string :role
      t.timestamps
    end
  end
end
