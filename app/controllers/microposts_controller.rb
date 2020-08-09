class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :destroy]
  before_action :correct_user, only: :destroy

  def index
    @microposts = Micropost.all
    @feed_items = current_user.feed
  end

  def show
    @user = User.find(params[:id])
    @feed_items = @user.my_feed
    #@microposts = @user.microposts.all
  end

  def new
    if logged_in?
      @micropost = current_user.microposts.build
    end
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
     # micropostオブジェクトのimageメソッドに添付された画像を追加（保存はしない）
     # --Actuve Storage APIのattachメソッドを使用
     #@micropost.image.attach(params[:micropost][:image])
    if @micropost.image.present?
      @micropost.save
      flash[:success] = "投稿が完了しました"
      redirect_to micropost_path(current_user)
    else
      flash.now[:notice]= "画像を添付してください"
      render new_micropost_path
    end
  end

  def edit
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました。"
      #request.referrerメソッド--フレンドリーフォワーディングのrequest.url変数（10.2.3）と似ていて、一つ前のURLを返す（ リスト 13.53 ）
    redirect_to request.referrer || root_url
  end

  def search
    #Viewのformで取得したパラメータをモデルに渡す
    #下記のself.searchメソッドは、micropostモデルで定義したもの
    @microposts = Micropost.search(params[:search])
    #@microposts = Micropost.search(search_params)　<==検索が失敗する
    if @microposts
      render 'search'
    else
      flash[:notice] = "該当がありませんでした。"
    end
  end


  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    # うまくいかない
    #def search_params
    #  params.permit(:search)
    #nd


end
