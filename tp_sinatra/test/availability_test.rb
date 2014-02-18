require_relative 'test_helper.rb'

class OneResourceTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @t_now = DateTime.now

    @user = User.create(username: 'user', email: 'a@b.com');
    @resource = Resource.create(name: 'Monitor', description: 'bonito');

    @booking1 = Booking.create(
      user: @user,
      resource: @resource,
      start_time: (@t_now + 1),
      end_time: (@t_now + 2),
      status: 'approved',
    )

    @booking2 = Booking.create(
      user: @user,
      resource: @resource,
      start_time: (@t_now + 366),
      end_time: (@t_now + 367),
      status: 'pending',
    )
  end

  def teardown 
    DatabaseCleaner.clean
  end

  def test_inexistent_resource
    get '/resources/1000/availability?date=2013-01-01&limit=3'
    assert_equal 404, last_response.status

    assert_empty last_response.body
  end

  def test_resource_availability
    query = "/resources/#{@resource.id}/availability?date=#{Date.today}&limit=3"
    get query
    assert_equal 200, last_response.status

    pattern = {
      availability: [
        {
          from: st_time(Date.today),
          to: st_time(@booking1.start_time),
          links: [
            {
              rel: "book",
              link: "example.org/resources/#{@resource.id}/bookings",
              method: "POST"
            },
            {
              rel: "resource",
              uri: "example.org/resources/#{@resource.id}"
            }
          ]
        },
        {
          from: st_time(@booking1.end_time),
          to: st_time(Date.today + 3),
          links: [
            {
              rel: "book",
              link: "example.org/resources/#{@resource.id}/bookings",
              method: "POST"
            },
            {
              rel: "resource",
              uri: "example.org/resources/#{@resource.id}"
            }
          ]
        }
      ],
      links:[
        { 
          rel: 'self',
          link: "example.org"+query
        }
      ]
    }

    matcher = assert_json_match pattern, last_response.body
  end
end
