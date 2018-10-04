class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :calendar, index: true
      t.string :text
      t.date :date

      t.timestamps
    end
  end
end
