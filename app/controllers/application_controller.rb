class ApplicationController < ActionController::Base
  include SessionsHelper


  private

  # ログイン済みユーザーか確認
  def logged_in_user
      #logged_in? メソッドは、sessions.helperで定義したもの
    unless logged_in?
      store_location #リスト 10.31 (sessions_helper.rbで定義したメソッド)
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
end
