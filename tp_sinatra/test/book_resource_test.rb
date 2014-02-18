require_relative 'test_helper.rb'

class OneResourceTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @user = User.create(username: 'user', email: 'a@b.com');
    @resource = Resource.create(name: 'Monitor', description: 'bonito');
  end

  def teardown 
    DatabaseCleaner.clean
  end

  def test_book_resource
    @t_now = DateTime.now

    post "/resources/#{@resource.id}/bookings?from=#{st_time(@t_now + 1)}&to=#{st_time(@t_now + 2)}"
    assert_equal 201, last_response.status

    pattern = {
      book: 
      {
        from: st_time(@t_now + 1),
        to: st_time(@t_now + 2),
        status: 'pending',
        links: [
          {
            rel: "self",
            url: /example.org\/resources\/\d+\/bookings\/\d+/,
          },
          {
            rel: "accept",
            uri: /example.org\/resource\/\d+\/bookings\/\d+/,
            method: 'PUT'
          },
          {
            rel: "reject",
            uri: /example.org\/resource\/\d+\/bookings\/\d+/,
            method: 'DELETE'
          }
        ]
      }
    }

    matcher = assert_json_match pattern, last_response.body
  end
end
