require_relative 'test_helper.rb'

class OneResourceTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @user = User.create(username: 'user', email: 'anEmail');
    @resource = Resource.create(name: 'Monitor', description: 'bonito');
    @booking = Booking.create(
      user: @user,
      resource: @resource,
      start_time: 'aStart',
      end_time: 'anEnd',
      status: 'aStatus',
    )
  end

  def teardown 
    DatabaseCleaner.clean
  end

  def test_invalid_resource_link
    get '/resources/1000'
    assert_equal 404, last_response.status

    assert_empty last_response.body
  end

  def test_one_element
    get '/resources/'+@resource.id.to_s
    assert_equal 200, last_response.status

    pattern = {
      resource: 
        {
          name:        @resource.name,
          description: @resource.description,
          links: [
            {
              rel: "self",
              uri: "example.org/resource/"+@resource.id.to_s
            },
            {
              rel: "bookings",
              uri: "example.org/resource/"+@resource.id.to_s+"/bookings"
            }
          ]
        }
    }

    matcher = assert_json_match pattern, last_response.body
  end


  def test_resource_bookings
  end
end
