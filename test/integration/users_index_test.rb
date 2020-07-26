require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:foo)
  end

  test "index page" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
  end
end
