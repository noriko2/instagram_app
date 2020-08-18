class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @favorites = current_user.favorites.all
    @favorite_microposts = current_user.favorite_microposts
    #　上記と同じ意味
    #@favorite_microposts =  current_user.favorites.map{|favorite| favorite.micropost}
  end

  def create
    @favorite = current_user.favorites.build(micropost_params)
    if @favorite.save
      #「投稿をお気に入り」 を押したタイミングで通知レコードを作成
      @micropost = Micropost.find(params[:micropost_id])
      @micropost.create_notification_bookmark!(current_user)
      respond_to do |format|
        format.html { redirect_to microposts_path }
        format.js
      end
      #redirect_to microposts_path
    end
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, micropost_id: params[:micropost_id])
    #本人が、お気に入り登録した投稿のみ削除できる
    if @favorite && (current_user.id == @favorite.user_id)
      if @favorite.destroy
        @micropost = Micropost.find(params[:micropost_id])
        respond_to do |format|
          format.html { redirect_to microposts_path }
          format.js
        end
      end
    else
      #他人のお気に入り登録した投稿を削除しようとした場合は、投稿一覧ページにリダイレクト
      redirect_to microposts_path
    end
  end

  private
    def micropost_params
      params.permit(:micropost_id)
    end
end
