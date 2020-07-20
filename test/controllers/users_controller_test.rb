require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:foo)
    @other_user = users(:wanko)
  end


  test "should get signup" do
    get signup_url
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: {full_name: @user.full_name,
                                             user_name: @user.user_name,
                                                 email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end


  #間違ったユーザーが（ 他のユーザーのプロフィールを )編集しようとしたときのテスト
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
       #このとき、既にログイン済みのユーザーを対象としているため、ログインページではなくルートURLにリダイレクト
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { full_name: @user.full_name,
                                            user_name: @user.user_name,
                                                email: @user.email }}

    assert flash.empty?
    assert_redirected_to root_url
  end

end
