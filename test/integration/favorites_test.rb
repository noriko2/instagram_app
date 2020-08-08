require 'test_helper'

class FavoritesTest < ActionDispatch::IntegrationTest
  def setup
    @user  = users(:foo)
    @other = users(:wanko)
    @micropost = microposts(:orange) #wankoの投稿
    log_in_as(@user)
    @favorite = Favorite.create(micropost_id: @micropost.id, user_id: @user.id)

  end

  test "should bookmark if user logged_in" do

    get microposts_path
    @favorite.delete
    assert_difference '@user.favorites.count', 1 do
      post micropost_favorites_path(@micropost, @user)
    end
    assert_redirected_to microposts_path
  end


  test "should delete userself bookmark if user logged_in & userself" do
    get microposts_path
    assert_difference '@user.favorites.count', -1 do
      delete micropost_favorite_path(@micropost.id, @favorite.id)
    end
    assert_redirected_to microposts_path
  end


  test "should not delete other user's bookmark" do
    log_in_as(@other)
    get microposts_path
    assert_no_difference '@user.favorites.count' do
      delete micropost_favorite_path(@favorite.id, @micropost.id)
    end
  end

end
