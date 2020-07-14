class SessionsController < ApplicationController
  def new
  end

  # POST /login
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:success] = 'ログインしました'
      redirect_to(user) #user_url(user.id)の省略形
    else
      # flash.now‥‥1回目から0回目のリクエストまでに変更
      flash.now[:danger] = 'メールアドレスまたはパスワードが間違っています。'
      render 'new'
    end
  end

  def destroy
    log_out     #SessionsHelperで定義したメソッド
    redirect_to root_url
  end
end
