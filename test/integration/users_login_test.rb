require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:foo)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "",
                                       password: ""}
                             }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid email and invalid password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: @user.email,
                                    password: "invalid"}
                          }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email,
                                      password: 'password'}
                            }
    assert_redirected_to @user #user_path(@user)の略
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)  #マイページ
    delete logout_path # delete '/logout', to: 'sessions#destroy'
    assert_not is_logged_in?
    assert_redirected_to root_url

    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレート(delete logout_path)
    # --何も起きないことを確認する
    delete logout_path  # delete '/logout', to: 'sessions#destroy'

    follow_redirect!    #root_urlへ実際にredirect
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0

  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end

  test "login without remembering" do
    # cookieを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path #===>  sessionsコントローラのdestroyアクションが反応
    # cookieを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], "http://www.example.com" + edit_user_path(@user)
    assert_redirected_to login_url
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_nil session[:forwarding_url]
    full_name = "Foo Change"
    user_name = "Change_123"
    email = "change@sample.com"
    patch user_path(@user), params: {user: {full_name: full_name,
                                            user_name: user_name,
                                                email: email,
                                             password: '',
                                             password_confirmation: ''}}

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal full_name, @user.full_name
    assert_equal user_name, @user.user_name
    assert_equal email, @user.email
  end

end
