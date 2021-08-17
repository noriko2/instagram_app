require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:foo)
  end

  test "layout links" do
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
    get help_path
    assert_select "title", full_title("Help")
    get signup_path
    assert_select "title", full_title("Sign up")
  end

  test "layout links when logged in user" do
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", new_micropost_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", user_favorites_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", edit_password_path(@user)
    assert_select "a[href=?]", logout_path
  end
end
