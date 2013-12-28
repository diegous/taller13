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
  def test_valid_resource
    resource = Resource.new
    refute resource.valid?, "Empty resource"

    resource.name = "aName"
    resource.description = "My description"
    assert resource.valid?, "Valid resource"
  end
end
