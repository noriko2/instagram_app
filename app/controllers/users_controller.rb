class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

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

  private
    #ストロングパラメーターを定義(安全性のため、入力内容の制限)
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
