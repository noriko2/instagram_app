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
    get root_url
    @favorite.delete
    assert_difference '@user.favorites.count', 1 do
      post micropost_favorites_path(@micropost)
    end
    assert_redirected_to root_url
    assert_equal "text/html", @response.media_type
  end

  test "should bookmark with Ajax" do
    get root_url
    @favorite.delete
    assert_difference '@user.favorites.count', 1 do
      post micropost_favorites_path(@micropost), xhr: true
    end
    assert_template 'microposts/_unfavorite'
    assert_equal "text/javascript", @response.media_type
  end


  test "should delete userself bookmark if user logged_in & userself" do
    get root_url
    assert_difference '@user.favorites.count', -1 do
      delete micropost_favorite_path(@micropost.id, @favorite.id)
    end
    assert_redirected_to root_url
  end

  test "should delete userself bookmark with Ajex" do
    get root_url
    assert_difference '@user.favorites.count', -1 do
      delete micropost_favorite_path(@micropost.id, @favorite.id), xhr: true
    end
    assert_template 'microposts/_favorite'
    assert_equal "text/javascript", @response.media_type
  end


  test "should not delete other user's bookmark" do
    log_in_as(@other)
    get root_url
    assert_no_difference '@user.favorites.count' do
      delete micropost_favorite_path(@micropost.id, @favorite.id)
    end
    assert_redirected_to root_url
  end

end
