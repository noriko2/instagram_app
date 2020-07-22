class UsersController < ApplicationController
      # :logged_in_userはメソッド。メソッドを呼び出すときは、シンボルにするのが基本。
      # logged_in_userはメソッドは下記 privateに定義
      # before_actionは、logged_in_userを先に書き、 correct_userを後で書く。
      #  ( correct_userはログインしているのを前提にしているため )
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_or_correct_user, only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

    #POST /users ==> createアクション
  def create
    @user = User.new(user_params)
      #@user = User.new(params[:user]) ←安全性× Forbidden Attribute Errorが出る
    if @user.save
      log_in @user
      flash[:success] = "インスタグラムへようこそ！"
      redirect_to @user
      #上記は、redirect_to user_url(@user.id)と同じ
      # => showアクションへ /users/:id
    else
      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id]) <==correct_userメソッドで行っているため不要となった
  end

  def update
     #@user = User.find(params[:id]) <==correct_userメソッドで行っているため不要となった
    if @user.update(user_params)
      flash[:success] = "プロフィール情報を更新しました。"
      redirect_to @user #==> user_path(user)の略。 GET /users/:id => showアクションへ
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを削除しました"
    redirect_to root_url
  end


  private
    #ストロングパラメーターを定義(安全性のため、入力内容の制限)
    def user_params
      params.require(:user).permit(:full_name, :user_name, :email, :password, :password_confirmation)
    end

      # beforeアクション
      # ログイン済みユーザーかどうか確認
    def logged_in_user
        #logged_in? メソッドは、sessions.helperで定義したもの
      unless logged_in?
        store_location #リスト 10.31 (sessions_helper.rbで定義したメソッド)
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end

      # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
        #current_user?(user)は、sessions_helperで定義したメソッド (渡されたユーザーがカレントユーザーであればtrueを返す)
      redirect_to(root_url) unless current_user?(@user)
    end


     # 管理者または、自分のアカウントかどうか確認
    def admin_or_correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        if !current_user.admin?
          redirect_to(root_url)
        end
      end
    end

end
