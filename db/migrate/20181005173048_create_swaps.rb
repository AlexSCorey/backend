class CreateSwaps < ActiveRecord::Migration[5.2]
  def change
    create_table :swaps do |t|
      t.belongs_to :requesting_user, index: true
      t.belongs_to :accepting_user, index: true
      t.belongs_to :shift, index: true
      t.string :api_token

      t.timestamps
    end
  end
end
