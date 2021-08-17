class PasswordResetsController < ApplicationController

  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest #app/models/user.rbで定義
      @user.send_password_reset_email #app/models/user.rbで定義
      flash[:info] = "メールを送信しました。"
      redirect_to root_url
    else
      flash.now[:danger] = "ご登録のメールアドレスが見つかりませんでした。"
      render 'new'
    end
  end


  def edit
  end


  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      #パスワード再設定が成功したらダイジェストをnilにする( リスト 12.22)
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "パスワードが更新されました。"
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired? #app/models/user.rbで定義
        flash[:danger] = "パスワードの有効期限が切れています。"
        redirect_to new_password_reset_url
      end
    end

end
