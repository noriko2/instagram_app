class UserMailer < ApplicationMailer
  # mailerは、controllerと似ているが、
  # アクション名に引数を渡せる点と、戻り値が返ってくる点が異なる。

  def account_activation(user)
    @user = user
    mail to: user.email,
         subject: "アカウントの有効化"

    # return: mail objext(text/html)
  end


  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワードのリセット"
  end
end
