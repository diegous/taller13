class Resource < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :bookings
  has_many :users, through: :bookings
end
