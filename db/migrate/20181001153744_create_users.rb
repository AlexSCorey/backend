class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :phone_number
      t.string :name

      t.timestamps
    end
  end
end
