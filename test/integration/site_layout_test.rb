require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    get help_path
    assert_select "title", full_title("Help")
    get signup_path
    assert_select "title", full_title("Sign up")
  end
end
