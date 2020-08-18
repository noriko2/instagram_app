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

  #Viewのformで取得したパラメータをモデルに渡す
  #下記のself.searchメソッドは、micropostモデルで定義したもの
  # @microposts = Micropost.search(params[:search_words][:content])だとストロングパラメータがなく、
  #  whereメソッドで検索されたくないことも検索されてしまうためNG
  def search
    @microposts = Micropost.search(search_params)
    if !@microposts.empty? #配列が空の場合を除外( if @microposts とすると、@micropostsの配列が空の場合を除外できない)
      return
    else
      flash[:notice] = "該当がありませんでした。"
    end
    # render 'search' に行く。 #app/views/microposts/search.html.erbへ
  end


  private
    def search_params
      params.require(:search_words).permit(:content)
    end
    # where メソッドで値だけ検索するために、:contentの値を取り出す。
    #   WHERE (content LIKE '%飲み物"%') となり、検索に成功する。
    # これをしないと、WHERE (content LIKE '%{"content" => "飲み物"}%')というように
    #   ハッシュを検索してしまい、結果空の集合[]が返されてしまう
    #　NG　search_params = params[:search_words][:content]
    # 　　　一見良さそうに見えるが、攻撃されてしまう

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end




end
