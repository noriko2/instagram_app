require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:foo)
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title',  full_title(@user.user_name)
    assert_select 'p', text: @user.user_name
    #response.bodyにはそのページの完全なHTMLが含まれている（HTMLのbodyタグだけではない）。
    #--そのページのどこかにマイクロポストの投稿数が存在するのであれば、探し出してマッチできる
    assert_match @user.microposts.count.to_s, response.body
    @user.microposts.each do |micropost|
      if micropost.image
        assert_select 'div.flexbox'
        assert_select 'button.btn>img'
      end
    end
  end


end
