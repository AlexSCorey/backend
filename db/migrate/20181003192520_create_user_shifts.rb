class CreateUserShifts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_shifts do |t|
      t.belongs_to :user, index: true
      t.belongs_to :shift, index: true

      t.timestamps
    end
  end
end
