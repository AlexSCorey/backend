class CreateAvailabilityResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :availability_responses do |t|
      t.belongs_to :availability_request, index: true
      t.belongs_to :shift, index: true
      t.boolean :available

      t.timestamps
    end
  end
end
