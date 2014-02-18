require_relative 'test_helper.rb'

class OneResourceTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    t_now = DateTime.now

    @user = User.create(username: 'user', email: 'a@b.com');
    @resource = Resource.create(name: 'Monitor', description: 'bonito');

    @booking1 = Booking.create(
      user: @user,
      resource: @resource,
      start_time: (t_now + 1),
      end_time: (t_now + 2),
      status: 'approved',
    )

    @booking2 = Booking.create(
      user: @user,
      resource: @resource,
      start_time: (t_now + 366),
      end_time: (t_now + 367),
      status: 'pending',
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


  def test_resource_bookings_without_parameters
    test_uri = "/resources/#{@resource.id}/bookings?date=#{Date.today + 1}&limit=30&status=approved"

    get "/resources/#{@resource.id}/bookings"
#    assert_equal 200, last_response.status

    pattern = {
      bookings: [
        {
          start: String,# st_time(@booking1.start_time),
          end: String,
          status: String,
          user: String,

          links: [
            {
              rel: "self",
              uri: "example.org/resources/#{@resource.id}/bookings/#{@booking1.id}"
            },
            {
              rel: "resource",
              uri: "example.org/resources/#{@resource.id}"
            },
            {
              rel: "accept",
              uri: "example.org/resources/#{@resource.id}/bookings/#{@booking1.id}",
              method: "PUT"
            },
            {
              rel: "reject",
              uri: "example.org/resources/#{@resource.id}/bookings/#{@booking1.id}",
              method: "DELETE"
            },
          ]
       }
      ],
      links: [
        {
          rel: "self",
          uri: "example.org"+test_uri
        }
      ]
    }

    matcher = assert_json_match pattern, last_response.body
  end

  def unsovable_error_test_resource_bookings_with_default_parameters
    test_uri = "/resources/#{@resource.id}/bookings?date=#{Date.today + 1}&limit=30&status=approved"

    get test_uri
    assert_equal 200, last_response.status

    pattern = {
      bookings: [
        {
          start: String,# st_time(@booking1.start_time),
          end: String,
          status: String,
          user: String,

          links: [
            {
              rel: "self",
              uri: "example.org/resources/#{@resource.id}/bookings/#{@booking1.id}"
            },
            {
              rel: "resource",
              uri: "example.org/resources/#{@resource.id}"
            },
            {
              rel: "accept",
              uri: "example.org/resources/#{@resource.id}/bookings/#{@booking1.id}",
              method: "PUT"
            },
            {
              rel: "reject",
              uri: "example.org/resources/#{@resource.id}/bookings/#{@booking1.id}",
              method: "DELETE"
            },
          ]
       }
      ],
      links: [
        {
          rel: "self",
          uri: "example.org"+test_uri
        }
      ]
    }

    matcher = assert_json_match pattern, last_response.body
  end
end
