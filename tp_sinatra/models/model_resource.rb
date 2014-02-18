class Resource < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :bookings
  has_many :users, through: :bookings

  def availability(aStart, anEnd)
    myBookings = Booking.where(resource_id: self.id, status: 'approved').strict_between(aStart, anEnd).order(:start_time)
    
    slices = ([aStart] + myBookings.pluck(:start_time, :end_time).flatten.map{|d|st_time(d)} + [anEnd]).each_slice(2).to_a

    slices.map {|s| {from: s[0], to: s[1]}}
  end
end
