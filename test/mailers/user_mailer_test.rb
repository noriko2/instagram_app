require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:foo)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "アカウントの有効化", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.user_name,          mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join
    assert_match user.activation_token,   mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join
    assert_match CGI.escape(user.email),  mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join
  end

end
