require_relative 'test_helper.rb'

class ShowOneBookingTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @resource = Resource.create(name: 'Monitor', description: 'bonito');
  end

  def teardown 
    DatabaseCleaner.clean
  end

  def test_inexistent_booking
    get "/resources/#{@resource.id}/bookings/0"
    assert_equal 404, last_response.status

    assert_empty last_response.body
  end

  def test_show_booking
    @t_now = DateTime.now
    @start = st_time(@t_now + 10)
    @end   = st_time(@t_now + 11)

    booking = Booking.create(
      resource: @resource,
      start_time: @start,
      end_time: @end,
      status: 'pending',
    )

    get "/resources/#{@resource.id}/bookings/#{booking.id}"
    assert_equal 200, last_response.status

    pattern = {
      from: @start,
      to: @end,
      status: "pending",
      links: [
        {
          rel: "self",
          url: "example.org/resources/#{@resource.id}/bookings/#{booking.id}"
        },
        {
          rel: "resource",
          uri: "example.org/resource/#{@resource.id}",
        },
        {
          rel: "accept",
          uri: "example.org/resource/#{@resource.id}/bookings/#{booking.id}",
          method: "PUT"
        },
        {
          rel: "reject",
          uri: "example.org/resource/#{@resource.id}/bookings/#{booking.id}",
          method: "DELETE"
        }
      ]
    }

    matcher = assert_json_match pattern, last_response.body
  end
end
