require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new( full_name: "Examle User",
                      user_name: "Example_123",
                          email: "user@example.com",
                       password: "foobar",
                       password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "full_name should be present" do
    @user.full_name = "   "
    assert_not @user.valid?
  end

  test "user_name shoule be present" do
    @user.user_name = "   "
    assert_not @user.valid?
  end

  test "email shuld be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "full_name should not be too long" do
    @user.full_name = "a" * 51
    assert_not @user.valid?
  end

  test "user_name should not be too long" do
    @user.user_name = "a" * 51
    assert_not @user.valid?
  end

  test "emailshould not be too long" do
   @user.email = "a" * 244 + "@example.com"
   assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com
                         USER@foo.COM
                         A_US_ER@foo.bar.org
                         first.last@foo.jp
                         alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} shoule be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com
                           user_at_foo.org
                           user.name@example.
                           foo@bar_baz.com
                           doo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    #dupは、同じ属性を持つデータを複製するためのメソッド(リスト６.２５)
    duplicate_user = @user.dup #duplicate_userのemailは小文字
    # ↓ duplicate_userのemailは大文字、@userのemailは、代入さえれていないため小文字のまま
    #duplicate_user.email = @user.email.upcase
    #＠userのemailは小文字で保存される
    @user.save
    #メールアドレスでは大文字小文字が区別されないため、invalidであることを確認
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower_case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = 'a' * 5
     assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
        #ダイジェストが存在しない場合のauthenticated?のテスト
        #記憶トークンを空欄のままにしているのは、(リスト 9.17)
        #記憶トークンが使われる前にエラーが発生するので、記憶トークンの値は何でも構わないため
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    image = Rack::Test::UploadedFile.new(Rails.root.join('app', 'assets', 'images', 'sample_image.jpeg'), 'image/jpeg')
    @user.microposts.create!(content: "ユーザー削除に伴う投稿削除",image: image)
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    foo = users(:foo)
    wanko = users(:wanko)
    assert_not foo.following?(wanko)
    foo.follow(wanko)
    assert foo.following?(wanko)
    assert wanko.followers.include?(foo)
    foo.unfollow(wanko)
    assert_not foo.following?(wanko)
  end

  #フォロー中 fooさんー>>lana 、lana & archer->>fooフォロー
  #未フォロー fooさんー>>archer ×
  test "feed should have the right posts" do
    foo = users(:foo)
    archer = users(:archer)
    lana = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert foo.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    foo.microposts.each do |post_self|
      assert foo.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowed|
      assert_not foo.feed.include?(post_unfollowed)
    end
  end


end
