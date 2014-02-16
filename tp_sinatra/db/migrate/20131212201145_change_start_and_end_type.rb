class ChangeStartAndEndType < ActiveRecord::Migration
  def change
    change_table :bookings do |t|
      t.remove :start, :end
      t.datetime :start, :end
    end
  end
end
