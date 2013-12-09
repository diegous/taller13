#require 'test_helper'
require 'bundler'
require 'sinatra'
require 'test/unit'
require 'active_record'
require 'minitest/autorun'
require 'validates_email_format_of'

require_relative '../models/model_user'
require_relative '../models/model_booking'
require_relative '../models/model_resource'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/db.sqlite3'

class ModelTest < Minitest::Unit::TestCase
  def test_valid_user
    user = User.new
    refute user.valid?, "Empty user"

    user.username = "aUsername"
    user.email = "anEmail"
    refute user.valid?, "Wrong email format"

    user.email = "valid@example.com"
    assert user.valid?, "Valid user with valid email"
  end

  def test_valid_resource
    resource = Resource.new
    refute resource.valid?, "Empty resource"

    resource.name = "aName"
    resource.description = "My description"
    assert resource.valid?, "Valid resource"
  end

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
