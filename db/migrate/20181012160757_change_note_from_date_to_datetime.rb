class ChangeNoteFromDateToDatetime < ActiveRecord::Migration[5.2]
  def up
    change_column :notes, :date, :datetime
  end

  def down
    change_column :notes, :date, :date
  end
end
