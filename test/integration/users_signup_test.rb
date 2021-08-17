require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  #ActionMailerをresetする（バグの原因になる可能性があるため）
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { full_name: "",
                                         user_name: "",
                                             email: "user@invalid",
                                          password:              "foo",
                                          password_confirmation: "bar"}}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
  end


  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { full_name: "Example User",
                                         user_name: "Example_123",
                                             email: "user@example.com",
                                          password:              "password",
                                          password_confirmation: "password"}}
    end
    #ActionMailerが１つ作られていること
    assert_equal 1, ActionMailer::Base.deliveries.size
    # assignsメソッドを使うと対応するアクション内のインスタンス変数にアクセスできるようになる。
    # ex.Usersコントローラのcreateアクションでは@userというインスタンス変数が定義されているが（リスト 11.23）、テストでassigns(:user)と書くとこのインスタンス変数にアクセスできるようになる
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?  #test_helper.rbで定義したメソッド（SessionsHelperのメソッドはテストでは使えないため）
  end



end
