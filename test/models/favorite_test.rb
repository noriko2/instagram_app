require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase
  def setup
    @user = users(:foo)
    @micropost = microposts(:ants) #wankoの投稿
    @favorite = @user.favorites.build(micropost_id: @micropost.id)
  end


  test "should be valid" do
    assert @favorite.valid?
  end

  test "user id should be present" do
    @favorite.user_id = nil
    assert_not @favorite.valid?
  end

  test "micropost id should be present" do
    @favorite.micropost_id = nil
    assert_not @favorite.valid?
  end

end
