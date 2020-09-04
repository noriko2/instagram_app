class PasswordController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(password_params)
      flash[:success] = "パスワードを更新しました。"
      redirect_to @user #==> user_path(user)の略。 GET /users/:id => showアクションへ
    else
      render 'edit'
    end
  end

  private
      # beforeアクション
      # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
        #current_user?(user)は、sessions_helperで定義したメソッド (渡されたユーザーがカレントユーザーであればtrueを返す)
      redirect_to(root_url) unless current_user?(@user)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
