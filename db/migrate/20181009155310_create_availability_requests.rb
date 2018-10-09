class CreateAvailabilityRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :availability_requests do |t|
      t.belongs_to :user, index: true
      t.belongs_to :calendar, index: true
      t.boolean :complete
      t.string :api_token

      t.timestamps
    end
  end
end
