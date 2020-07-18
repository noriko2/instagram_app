#sessions_helper.rbの内容のテスト（ リスト9.31 ）
#永続的セッションのテスト


#require 'test_helper'ーーテストで使うデフォルト設定としてtest_helper.rbが読み込まれ、
#test_helper.rbに記載したメソッドがこのファイルで使用できるようになる
require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:foo)
    remember(@user)
  end

  test "current_user returns right user when session is nill" do
    assert_equal @user,current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest id wrong" do
      #ユーザーの記憶ダイジェストが記憶トークンと正しく対応していない場合に現在のユーザーがnilになるかどうかをチェック
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
