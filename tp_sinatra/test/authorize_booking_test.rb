require_relative 'test_helper.rb'

class OneResourceTest < Minitest::Unit::TestCase
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
    put "/resources/#{@resource.id}/bookings/0"
    assert_equal 404, last_response.status

    assert_empty last_response.body
  end

  def test_authorizing
    @t_now = DateTime.now
    @start = st_time(@t_now + 10)
    @end   = st_time(@t_now + 11)

    booking = Booking.create(
      resource: @resource,
      start_time: @start,
      end_time: @end,
      status: 'pending',
    )

    put "/resources/#{@resource.id}/bookings/#{booking.id}"
    assert_equal 200, last_response.status

    pattern = {
      book:
      {
        from: @start,
        to: @end,
        status: "apporved",
        links: [
          {
            rel: "self",
            url: "example.org/resources/#{@resource.id}/bookings/#{booking.id}"
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
          },
          {
            rel: "resource",
            url: "example.org/resources/#{@resource.id}"
          }      
        ]
      }
    }

    matcher = assert_json_match pattern, last_response.body

    assert_equal 'approved', Booking.find_by(id: booking.id).status
  end

  def test_confilct
    t_now  = DateTime.now
    t_start= st_time(t_now + 1)
    t_end  = st_time(t_now + 2)
    

    booking1 = Booking.create(
      resource: @resource,
      start_time: t_start,
      end_time: t_end,
      status: 'approved',
    )

    booking2 = Booking.create(
      resource: @resource,
      start_time: t_start,
      end_time: t_end,
      status: 'pending',
    )

    put "/resources/#{@resource.id}/bookings/#{booking2.id}"
    assert_equal 409, last_response.status

    assert_empty last_response.body
  end
end
