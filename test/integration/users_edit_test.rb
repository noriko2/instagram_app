require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foo)
    @admin = users(:foo)
    @non_admin = users(:wanko)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { full_name: '',
                                              user_name: '',
                                                  email: 'foo@invalid',
                                               password: 'foo',
                                               password_confirmation: 'bar' }}
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 5 errors'
  end


  test "successful edit with friendly forwarding" do
    get edit_user_path(@user) #リスト 10.29: フレンドリーフォワーディングのテスト(以下３行)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    assert_template 'users/edit'
    full_name = "Yamada Taro"
    user_name = "Yamada_123"
    email = "yamada@sample.com"
    #パスワードは入力しなくても情報を更新できるようにする
    patch user_path(@user), params:{ user: { full_name: full_name,
                                             user_name: user_name,
                                                 email: email,
                                              password: "",
                                              password_confirmation: "" }}

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal full_name, @user.full_name
    assert_equal user_name, @user.user_name
    assert_equal email, @user.email
  end

  test "edit admin page as admin/userself not including delete links" do
    log_in_as(@admin)
    get edit_user_path(@admin)
    assert_template 'users/edit'
    assert_select 'a', text: 'アカウントを削除', count: 0
  end

  test "edit non-admin as non-admin/userself including delete links" do
    log_in_as(@non_admin)
    get edit_user_path(@non_admin)
    assert_template 'users/edit'
    assert_select 'a', text: 'アカウントを削除'
  end
end
