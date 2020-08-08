require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:foo)
    @other = users(:wanko)
    @micropost = microposts(:orange) #wankoの投稿
    @comment = comments(:doglove_comment) #fooが投稿したwankoの投稿へのコメント
    log_in_as(@user)
  end


  test "should comment to micropost if user logged_in" do

    get microposts_path
    assert_difference '@user.comments.count', 1 do
      comment = "投稿にコメントしたよ"
      post micropost_comments_path(@micropost, @user),
              params: {comment: {comment: comment, micropost_id: @micropost.id}}
    end
    assert_redirected_to root_url
  end


  test "should delete userself comment to micropost if user logged_in & userself" do
    get microposts_path
    assert_difference '@user.comments.count', -1 do
      delete micropost_comment_path(@micropost.id, @comment.id)
    end
    assert_redirected_to root_url
  end
  

  test "should not delete otheruser's comment to micropost" do
    log_in_as(@other)
    get microposts_path
    assert_no_difference '@user.comments.count' do
      delete micropost_comment_path(@micropost.id, @comment.id)
    end
  end
end
