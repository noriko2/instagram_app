require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:foo)
  end

  test "micropost interface" do
    log_in_as(@user)
    get new_micropost_path
    # 無効な送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: {content: ""} }
    end
    assert_select 'div#error_explanation'
    # 有効な送信
    content = "有効な投稿"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: {content: content} }
    end
    assert_redirected_to micropost_path(@user)
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: '投稿を削除'
    first_micropost = @user.microposts.first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス（削除リンクがないことを確認）
    get user_path(users(:wanko))
    assert_select 'a', text: '投稿を削除', count: 0
  end
end
