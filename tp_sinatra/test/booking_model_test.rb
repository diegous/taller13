require 'bundler'
require 'sinatra'
require 'test/unit'
require 'active_record'
require 'minitest/autorun'
require 'validates_email_format_of'

require_relative '../models/model_user.rb'
require_relative '../models/model_booking.rb'
require_relative '../models/model_resource.rb'
require_relative '../helpers/simple_helpers.rb'

T_NOW = DateTime.now

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/db.sqlite3'

class BookingModelTest < Minitest::Unit::TestCase
  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @user = User.create(username: 'user', email: 'a@b.com')
    @resource = Resource.create(name: 'Monitor', description: 'bonito')

    @booking = Booking.new do |b|
      b.user = @user
      b.resource = @resource
      b.status = 'pending'
      b.start_time = (T_NOW + 1)
      b.end_time = (T_NOW + 2)
    end
  end

  def teardown
    DatabaseCleaner.clean
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

    @booking.start_time = (T_NOW - 1) 
    refute @booking.valid?, "Cant start in the past, doc!"

    @booking.start_time = (T_NOW + 1) 
    assert @booking.valid?, @booking.errors.messages
  end

  def test_valid_end_time
    @booking.end_time = nil
    refute @booking.valid?, "Booking should have an end"

    @booking.end_time = 'anEnd'
    refute @booking.valid?, "Start isn't even a date!"

    @booking.end_time = (T_NOW - 1) 
    refute @booking.valid?, "Cant end before it starts"

    @booking.end_time = (T_NOW + 2) 
    assert @booking.valid?, @booking.errors.messages
  end

  def test_bookings_between_method
    book = -> d1, d2 {Booking.create(user: @user, resource: @resource, status: 'pending', start_time: (T_NOW + d1), end_time: (T_NOW + d2))}

    b1 = book.call(1, 3)
    b2 = book.call(2, 4)
    b3 = book.call(3, 5)

    query = -> date_1, date_2 {(Booking.bookings_between((T_NOW + date_1), (T_NOW + date_2))).to_a}

    assert_equal query.call(0, 6), [b1, b2, b3]
    assert_equal query.call(0, 1), [b1]
    assert_equal query.call(0, 2), [b1, b2]
    assert_equal query.call(2, 3), [b1, b2, b3]
    assert_equal query.call(2, 4), [b1, b2, b3]
    assert_equal query.call(3, 5), [b1, b2, b3]
    assert_equal query.call(4, 5), [b2, b3]
    assert_equal query.call(5, 5), [b3]
  end
end
