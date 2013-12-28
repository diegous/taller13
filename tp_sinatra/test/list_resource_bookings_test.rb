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

class ListResourceBookingsTest < Minitest::Unit::TestCase
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
end
