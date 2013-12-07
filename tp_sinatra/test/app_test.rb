require 'test_helper'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_get_root
    get '/'
    assert_equal 200, last_response.status
    assert_equal 'Hello World', last_response.body
  end

  def test_list_all_resources
    get '/resources'
    expected
  end
end
