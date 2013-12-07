class Booking < ActiveRecord::Base
  validates :start, :status, presence: true

  belongs_to :users
  belongs_to :resources
end
