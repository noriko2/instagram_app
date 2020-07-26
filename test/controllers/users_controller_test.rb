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

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
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

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user),params: { user: { password:              "password",
                                                   password_confirmation: "password",
                                                      admin: true}}
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destory when logged in as other user" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should redirect destory delete other user account when logged in as admin user" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end

  test "should redirect destory and delete userself account  when logged in as user" do
    log_in_as(@other_user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a non-admin"  do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

end
