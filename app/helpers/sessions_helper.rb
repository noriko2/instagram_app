#SessionsControllerで使える便利メソッド
module SessionsHelper

  #渡されたユーザーでログインする
  def log_in(user)
    #ブラウザとrailsサーバーの２つにsession情報を保存。
    #sessionメソッドは、railsで事前定義済
    session[:user_id] = user.id
  end


  #ユーザーのセッションを永続的にする(ログインしまままにするにチェックした時に実行される)
  def remember(user)
    #user.remember
      #--models/user.rbで定義したメソッド(永続セッションのためにユーザーを(remember_digestカラムに値)DBに記憶)
      #--self.remember_token に User.new_tokenを代入
    user.remember
    cookies.permanent.signed[:user_id] = user.id #cookiesの:user_idを半永久化
    cookies.permanent[:remember_token] = user.remember_token #cookiesの:remember_tokenを半永久化
  end

  #現在ログイン中のユーザー、記憶トークンcookieに対応するユーザーを返す(リスト 9.9)
  def current_user
       #if‥‥‥‥一時セッションに値がある場合
       #ログインだけして、ログインしたままにチェックを入力していない or ログイン＆ログインしたままにチェックを入力
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      #elsif‥‥‥一時セッションに値がない場合、cookiesには半永久化した値がある場合
      #一時セッションに値がない（ログインしたままにチェックを入力し、サイトを一度離れ、再度訪問した時）
      #cookies.signed[:user_id]とすることで、暗号化した値を復合化できる(暗号化されていない元の値に戻せる)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end
    end
  end

  #ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end


  # 永続的セッションを破棄する（ ログインしたままにするチェックを破棄 ）
  def forget(user)
    #user.forget
      #app/models/user.rbで定義したメソッド
      #--ユーザーのログイン情報を破棄( remember_digestの値を nil にする)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
