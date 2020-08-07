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
      redirect_to microposts_path
    end
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, micropost_id: params[:micropost_id])
    if @favorite.destroy
      redirect_to microposts_path
    end
  end

  private
    def micropost_params
      params.permit(:micropost_id)
    end
end
