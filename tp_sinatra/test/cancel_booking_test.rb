require_relative 'test_helper.rb'

class OneResourceTest < Minitest::Unit::TestCase
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

  def test_delete_booking
    t_now = DateTime.now

    resource = Resource.create(name: 'Monitor', description: 'bonito');
    booking = Booking.create(
      resource: resource,
      start_time: st_time(t_now + 1),
      end_time: st_time(t_now + 2),
      status: 'pending'
    )

    delete "/resources/#{resource.id}/bookings/#{booking.id}"
    assert_equal 200, last_response.status

    assert_empty last_response.body

    refute Booking.find_by(id: booking.id)
  end

  def test_delete_nonexistent_booking
    resource = Resource.create(name: 'Monitor', description: 'bonito');

    delete "/resources/#{resource.id}/bookings/0"
    assert_equal 404, last_response.status

    assert_empty last_response.body
  end
end
