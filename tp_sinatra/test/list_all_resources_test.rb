require_relative 'test_helper.rb'

class ListAllResourcesTest < Minitest::Unit::TestCase
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
    assert_equal 200, last_response.status

    pattern = {
      resources: []
    }

    matcher = assert_json_match pattern, last_response.body
  end

  def test_one_element_resource_list
    resource = Resource.create(name: 'Monitor', description: 'bonito')
    
    get '/resources'
    assert_equal 200, last_response.status

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

  def test_ten_elements_resource_list
    resources = (1..10).collect {|i| {name: 'n'+(i.to_s), description: 'd'+(i.to_s)}}
    resources.each {|resource| Resource.create(name: resource[:name], description: resource[:description])}

    get '/resources'
    assert_equal 200, last_response.status

    pattern = {
      resources: 
        resources.collect{|resource|
          {
            name:        resource[:name],
            description: resource[:description],
              links: [
                rel: "self",
                uri: /example.org\/resource\/\d+\z/
              ]
          }
        }
      
    }

    matcher = assert_json_match pattern, last_response.body
  end
end
