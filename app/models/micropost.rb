class Micropost < ApplicationRecord
  #rails generate model Micropost content:text user:references
  # により生成されたMicropostモデル
  # user:references と記載することにより、 belongs_to :user　になる

  #マイクロポストがユーザーに所属する（belongs_to）関連付け
  belongs_to :user

  # Micropostモデルに画像を追加(1枚だけの設定)
  # micropost.imageのようにimageはメソッドとして今後使える
  has_one_attached :image

  # default_scopeでマイクロポストを順序付ける（ 降順 descending ）
  # 新しい投稿から古い投稿の順に並び替え
  default_scope -> { self.order(created_at: :desc) }

  #user_idカラムのバリデーション
  validates :user_id, presence: true

  #contentカラムのバリデーション
  validates :content, presence: true,
                        length: { maximum: 140 }

  #画像バリデーションを追加
  # Active Storageバリデーション用のgemを追加したから使える
  validates :image, content_type: {in: %w[image/jpeg image/gif image/png],
                                   message: "有効な画像形式にしてください" },
                            size: { less_than: 5.megabytes,
                                      message: "5MB未満の画像にしてください"}

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_fill: [400, 400])
  end
end
