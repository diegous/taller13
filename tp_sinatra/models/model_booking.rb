class Booking < ActiveRecord::Base
  validates :user, :resource, :start, :status, presence: true

  belongs_to :user
  belongs_to :resource
end
