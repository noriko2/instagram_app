class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    #1. nilガード
    #２. すでに有効化されているユーザーをブロック（２回目以降のクリックを無効化)
    #3. 認証が有効かチェック
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate #activate...app/models/user.rbで定義したメソッド
      log_in user
      flash[:success] = "アカウントが有効化されました。"
      redirect_to user
    else
      flash[:danger] = "アカウントの有効化に失敗しました。"
      redirect_to root_url
    end
  end
end
