class RenameBookingColumns < ActiveRecord::Migration
  def change
    change_table :bookings do |t|
      t.rename :resources_id, :resource_id
      t.rename :users_id, :user_id
    end
  end

  def down
  end
end
