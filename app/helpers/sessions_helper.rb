#SessionsControllerで使える便利メソッド
module SessionsHelper

  #渡されたユーザーでログインする
  def log_in(user)
    #ブラウザとrailsサーバーの２つにsession情報を保存。
    #sessionメソッドは、railsで事前定義済
    session[:user_id] = user.id
  end

  #現在ログイン中のユーザーを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  #ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
