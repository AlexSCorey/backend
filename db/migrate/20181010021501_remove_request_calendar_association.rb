class RemoveRequestCalendarAssociation < ActiveRecord::Migration[5.2]
  def change
    remove_column :availability_requests, :calendar_id
  end
end
