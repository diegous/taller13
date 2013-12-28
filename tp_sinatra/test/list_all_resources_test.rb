require 'bundler'
require 'sinatra'
require 'test/unit'
require 'rack/test'
require 'active_record'
require 'minitest/autorun'
require 'database_cleaner'
require 'validates_email_format_of'

require_relative '../models/model_user.rb'
require_relative '../models/model_booking.rb'
require_relative '../models/model_resource.rb'

require_relative '../app.rb'

DatabaseCleaner.strategy = :transaction

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'db/db.sqlite3'

class ListAllResourcesTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown 
    DatabaseCleaner.clean
  end

  def test_empty_resource_list
    get '/resources'
    expected = {resources: []}.to_json

    assert_equal expected, last_response.body
  end

  def test_adding_one_resource
    resource = Resource.create(name: 'Monitor', description: 'bonito')
    get '/resources'

    expected = {resources: [{
        name: resource.name, 
        description: resource.description,
        links: [
          rel: "self",
          uri: "example.org/resource/"+resource.id.to_s
        ]
      }]}.to_json

    assert_equal expected, last_response.body
  end

#  def test_resource_availability
#    get "/resources/1/availability?date=2012-05-30&limit=30"
#    get "/resources/1/availability?date=2013-11-12&limit=3"
#  end
#
#  def test_booking_a_resource
#  end
#
#  def test_cancel_booking
#  end
#
#  def test_authorize_a_booking
#  end
#
#  def test_view_a_booking
#  end
end
