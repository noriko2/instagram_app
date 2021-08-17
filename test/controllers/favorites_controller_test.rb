require 'test_helper'

class FavoritesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
    @user = users(:foo)
  end

  test "create should require logged-in user" do
    assert_no_difference 'Favorite.count' do
      post micropost_favorites_path(@micropost)
      # => favoritesコントローラのcreateアクションへ
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Favorite.count' do
      delete micropost_favorite_path(@micropost, @user.id)
      # => favoritesコントローラのdestroyアクションへ
    end
    assert_redirected_to login_url
  end

end
