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
  def setup
    @user = User.new
    @resource = Resource.new
    @booking = Booking.new do |b|
      b.user = @user
      b.resource = @resource
      b.status = 'pending'
      b.start_time = (DateTime.now + 1).to_s
      b.end_time = (DateTime.now + 2).to_s
    end
  end

  def test_booking_not_empty
    booking = Booking.new
    refute booking.valid?, "Empty booking"

    assert @booking.valid?, @booking.errors.messages
  end

  def test_valid_status
    @booking.status = nil
    refute @booking.valid?, "Booking should have a status"

    @booking.status = 'aStatus'
    refute @booking.valid?, "Should be an invalid status"

    @booking.status = 'pending'
    assert @booking.valid?, "Should be a valid status"

    @booking.status = 'approved'
    assert @booking.valid?, "Should be a valid status"
  end

  def test_valid_start_time
    @booking.start_time = nil
    refute @booking.valid?, "Booking should have a start"

    @booking.start_time = 'aStart'
    refute @booking.valid?, "Start isn't even a date!"

    @booking.start_time = (DateTime.now - 1).to_s 
    refute @booking.valid?, "Cant start in the past, doc!"

    @booking.start_time = (DateTime.now + 1).to_s 
    assert @booking.valid?, @booking.errors.messages
  end

  def test_valid_end_time
    @booking.end_time = nil
    refute @booking.valid?, "Booking should have an end"

    @booking.end_time = 'anEnd'
    refute @booking.valid?, "Start isn't even a date!"

    @booking.end_time = (DateTime.now - 1).to_s 
    refute @booking.valid?, "Cant end before it starts"

    @booking.end_time = (DateTime.now + 2).to_s 
    assert @booking.valid?, @booking.errors.messages
  end
end
