require_relative 'test_helper'

class UserModelTest < Minitest::Unit::TestCase
  def test_valid_user
    user = User.new
    refute user.valid?, "Empty user"

    user.username = "aUsername"
    refute user.valid?, "User missing email"

    user.username = nil
    user.email = "an email"
    refute user.valid? "User missing username"

    user.username = "aUsername"
    user.email = "anEmail"
    refute user.valid?, "Wrong email format"

    user.email = "valid@example.com"
    assert user.valid?, "Valid user with valid email"
  end
end
