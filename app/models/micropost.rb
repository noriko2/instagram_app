class Micropost < ApplicationRecord
  #rails generate model Micropost content:text user:references
  # により生成されたMicropostモデル
  # user:references と記載することにより、 belongs_to :user　になる

  #マイクロポストがユーザーに所属する（belongs_to）関連付け
  belongs_to :user

  has_many :favorites, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :notifications, dependent: :destroy


  validates :image, presence: true

  # Micropostモデルのimageカラムと、アップローダーImageUploaderを紐付け
  # ImageUploaderは app/uploaders/image_uploader.rbのクラスの名前
  mount_uploader :image, ImageUploader


  # Micropostモデルに画像を追加(1枚だけの設定)
  # micropost.imageのようにimageはメソッドとして今後使える
  #has_one_attached :image

  # default_scopeでマイクロポストを順序付ける（ 降順 descending ）
  # 新しい投稿から古い投稿の順に並び替え
  default_scope -> { self.order(created_at: :desc) }

  #user_idカラムのバリデーション
  validates :user_id, presence: true

  #contentカラムのバリデーション
  validates :content, presence: true,
                        length: { maximum: 140 }

  def bookmarked_by(user)
    Favorite.find_by(user_id: user.id, micropost_id: self.id)
  end


  #クラスメソッド(.new不要で使える) self.search(search_words)でもよい。
  def Micropost.search(search_words)
       # search_wordsの戻り値は、{"content" => "飲み物"} というハッシュ。
       # このまま検索するとハッシュごと検索されてしまい、空の集合[]が返されるため、
       # 値だけ取り出す。 search['content']　===> "飲み物" という値だけ返される
       # search[:content]だとうまく取り出せない
    # words に'content'キーの値('飲み物'）を代入 & 代入した結果がnilではないかチェック
    if (words = search_words['content'])
      # LIKE '検索文字' で、文字列検索を行う.　「 % % 」は部分検索。
      Micropost.where(['content LIKE ?', "%#{words}%"])
      # ==> 該当がない時は、空の集合[]を返す
    end
  end


  def create_notification_bookmark!(current_user)
    # すでに 「お気に入り」 されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and micropost_id = ? and action = ?", current_user.id, user_id, self.id, 'favorite'])
    # お気に入りされていない場合のみ、通知レコードを作成
    # temp.empty? だと、tempがnilの場合、エラーが出てしまうためNG
    if temp.blank?
      notification = current_user.active_notifications.build(
                                micropost_id: self.id,
                                  visited_id: user_id,
                                      action: 'favorite'
                                )
      # 自分の投稿に対するお気に入りの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end


  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
        #投稿にコメントしているユーザーIDのリストを取得する
        #自分のコメントは除外する
        #重複した場合は削除する
    # Commentから :user_id一覧を取り出し、micropost_id　が自分自身のmicropost_idを探し、user_idが現在ログイン中のidを除外し、重複レコードをまとめる
    # distinctメソッドは、重複レコードを1つにまとめるためのメソッド
    temp_ids = Comment.select(:user_id).where(micropost_id: self.id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      #save_notification_comment!( , , )は、下記で定義したメソッド
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end


  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.build(
                            micropost_id: self.id,
                              comment_id: comment_id,
                              visited_id: visited_id,
                                  action: 'comment'
                              )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited.id
      notification.checked = true
    end
    notification.save if notification.valid?
  end



  # 表示用のリサイズ済み画像を返す
  #def display_image
  #  image.variant(resize_to_fill: [400, 400])
  #end


  #画像バリデーションを追加
  # Active Storageバリデーション用のgemを追加したから使える
  #validates :image, content_type: {in: %w[image/jpeg image/png],
  #                                 message: "有効な画像形式にしてください" },
  #                          size: { less_than: 5.megabytes,
  #                                    message: "5MB未満の画像にしてください"}
end
