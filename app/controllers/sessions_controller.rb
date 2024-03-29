class SessionsController < ApplicationController
  def new
  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
           #remember(user) --- sessions_helperで定義したメソッド
        params[:session][:remember_me] == "1" ? remember(user):forget(user) #リスト９.２３
        #flash[:success] = 'ログインしました'
        redirect_back_or(user)  #sessions_helper.rbで定義したメソッド
        #redirect_to(user) #user_url(user.id)の省略形
      else
        message = "アカウントが有効化されていません。"
        message += "アカウント有効化のためのメールを確認してください。"
        flash[:warning] = message
        redirect_to root_url
      end

    else
        # flash.now‥‥1回目から0回目のリクエストまでに変更
        flash.now[:danger] = 'メールアドレスまたはパスワードが間違っています。'
        render 'new'
    end
  end


  def destroy
       # log_out‥‥‥SessionsHelperで定義したメソッド
       # if logged_in?‥‥‥連続ログアウトのバグの解消( リスト9.16 )
    log_out if logged_in?
    redirect_to root_url
  end

end
