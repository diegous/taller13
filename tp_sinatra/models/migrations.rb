class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
  end
end
# duda: hace falta/que es index? el email no es clave primaria,no?

class CreateBooking < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :start, :end, :status
      t.references :resources, :users
  end
end

class CreateResource < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.text :description
  end
end
