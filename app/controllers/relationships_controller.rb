class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
     #follow(other_user)メソッドは、models/user.rb で定義
    current_user.follow(@user)
        # RelationshipsコントローラでAjaxリクエストに対応
        #ブロック内のコードのうち、どちらか1行が実行される
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
       #redirect_to user
  end


  # DELETE /relationships/:id(.:format) => destroyアクション
  # params[:id]は、 上記の :id
  # その:idは、 form_with(model: current_user.active_relationships.find_by(followed_id: @user.id)で、
  # Relationshipsテーブルのid番号を取得
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
        # RelationshipsコントローラでAjaxリクエストに対応
        #ブロック内のコードのうち、どちらか1行が実行される
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
      #redirect_to user
  end
end
