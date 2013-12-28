require 'bundler'
require 'sinatra'
require 'test/unit'
require 'active_record'
require 'minitest/autorun'
require 'validates_email_format_of'

require_relative '../models/model_user.rb'
require_relative '../models/model_booking.rb'
require_relative '../models/model_resource.rb'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/db.sqlite3'

class BookingModelTest < Minitest::Unit::TestCase
  def test_valid_booking
    booking = Booking.new
    refute booking.valid?, "Empty booking"

    user = User.new
    resource = Resource.new

    booking.user = user
    booking.resource = resource
    booking.start = 'aStart'
    refute booking.valid?, "Booking missing status"

    booking.status = 'aSatus'
    booking.user = nil
    refute booking.valid?, "Booking missing user"

    booking.user = user 
    booking.resource = nil
    refute booking.valid?, "Booking missing resource"

    booking.resource = resource
    booking.start = nil
    refute booking.valid?, "Booking missing start"
    
    booking.start = 'aStart'
    assert booking.valid?, "Valid booking"
  end
end
