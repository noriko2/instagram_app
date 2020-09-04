require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
    @comment = comments(:doglove_comment)
    @user = users(:foo)
  end

  test "create should require logged-in user" do
    assert_no_difference 'Comment.count' do
      post micropost_comments_path(@micropost)
      # => commentsコントローラの createアクションへ
    end
    assert_redirected_to login_url
  end

  #ログインしていないと、fooさんがコメントしたwankoの投稿(orange)へのコメント（doglove）を削除できない
  test "destroy should require logged-in user" do
    assert_no_difference 'Comment.count' do
      delete micropost_comment_path(@micropost, @comment)
      # => commentsコントローラのdestroyアクションへ
    end
    assert_redirected_to login_url
  end
end
