class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.belongs_to :user, index: true
      t.string :api_token

      t.timestamps
    end
  end
end
