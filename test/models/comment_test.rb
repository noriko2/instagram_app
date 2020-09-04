require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:foo)
    @micropost = microposts(:ants) #wankoの投稿
    @comment = @user.comments.build(comment: "初めてのコメント", micropost_id: @micropost.id)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "micropost id should be present" do
    @comment.micropost_id = nil
    assert_not @comment.valid?
  end

  test "content should be present" do
    @comment.comment = "   "
    assert_not @comment.valid?
  end

  test "content should be at most 140 characters" do
    @comment.comment = "a" * 141
    assert_not @comment.valid?
  end

  test "order should be most recent first" do
    assert_equal comments(:most_recent_comment), Comment.first
  end
end
