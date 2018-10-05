class CreateUsershifts < ActiveRecord::Migration[5.2]
  def change
    create_table :usershifts do |t|
      t.belongs_to :user, index: true
      t.belongs_to :shift, index: true

      t.timestamps
    end
  end
end
