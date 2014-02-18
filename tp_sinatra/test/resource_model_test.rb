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

class ResourceModelTest < Minitest::Unit::TestCase
  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @user = User.create(username: 'user', email: 'a@b.com')
    @resource = Resource.create(name: 'Monitor', description: 'bonito')

    @t_now = DateTime.now

    @booking1 = Booking.create(
      user: @user,
      resource: @resource,
      status: 'approved',
      start_time: st_time(@t_now + 1),
      end_time: st_time(@t_now + 2)
    )

    @booking2 = Booking.create(
      user: @user,
      resource: @resource,
      status: 'pending',
      start_time: st_time(@t_now + 2),
      end_time: st_time(@t_now + 3)
    )

    @booking3 = Booking.create(
      user: @user,
      resource: @resource,
      status: 'approved',
      start_time: st_time(@t_now + 3),
      end_time: st_time(@t_now + 4)
    )
  end

  def teardown
    DatabaseCleaner.clean
  end

  def test_valid_resource
    resource = Resource.new
    refute resource.valid?, "Empty resource"

    resource.name = "aName"
    resource.description = "My description"
    assert resource.valid?, "Valid resource"
  end

  def test_availability
    availability = [
      {
        from: st_time(@t_now.to_date),
        to: st_time(@booking1.start_time)
      },
      {
        from: st_time(@booking1.end_time),
        to: st_time(@booking3.start_time)
      },
      {
        from: st_time(@booking3.end_time),
        to: st_time(@t_now.to_date + 5 )
      }
    ]

    assert_equal availability, @resource.availability(st_time(@t_now.to_date), st_time(@t_now.to_date + 5))
  end
end
