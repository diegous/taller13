require 'minitest/autorun'
require 'rack/test'
require_relative 'server'

class HelloWorldTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_saludo
    get '/saludo'
    assert_equal 200, last_response.status
    assert_equal 'Hola Mundo!', last_response.body
  end

  def test_saludo_juan
    get '/saludo/juan'
    assert_equal 200, last_response.status
    assert_equal 'Hola juan!', last_response.body
  end
 
end
