require 'bundler'
require 'sinatra'
require 'test/unit'
require 'active_record'
require 'minitest/autorun'
#require 'validates_email_format_of'

require_relative '../models/model_user.rb'
require_relative '../models/model_booking.rb'
require_relative '../models/model_resource.rb'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/db.sqlite3'

class UserModelTest < Minitest::Unit::TestCase
  def test_valid_user
    user = User.new
    refute user.valid?, "Empty user"

    user.username = "aUsername"
    user.email = "anEmail"
    refute user.valid?, "Wrong email format"

    user.email = "valid@example.com"
    assert user.valid?, "Valid user with valid email"
  end
end
