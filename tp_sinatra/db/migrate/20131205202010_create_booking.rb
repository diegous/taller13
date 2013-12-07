class CreateBooking < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :start, :end, :status
      t.references :resources, :users
    end
  end
end

