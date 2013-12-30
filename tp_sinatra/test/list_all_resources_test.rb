require_relative 'test_helper.rb'

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

    pattern = {
      resources: []
    }

    matcher = assert_json_match pattern, last_response.body
  end

  def test_adding_one_resource
    resource = Resource.create(name: 'Monitor', description: 'bonito')
    get '/resources'

    pattern = {
      resources: [
        {
          name:        resource.name,
          description: resource.description,
          links: [
            rel: "self",
            uri: "example.org/resource/"+resource.id.to_s
          ]
        }
      ]
    }

    matcher = assert_json_match pattern, last_response.body
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
