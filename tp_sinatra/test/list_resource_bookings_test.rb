require_relative 'test_helper'

class ListResourceBookingsTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
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
