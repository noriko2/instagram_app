class Micropost < ApplicationRecord
  #rails generate model Micropost content:text user:references
  # により生成されたMicropostモデル
  # user:references と記載することにより、 belongs_to :user　になる

  #マイクロポストがユーザーに所属する（belongs_to）関連付け
  belongs_to :user

  # default_scopeでマイクロポストを順序付ける（ 降順 descending ）
  # 新しい投稿から古い投稿の順に並び替え
  default_scope -> { self.order(created_at: :desc) }

  #user_idカラムのバリデーション
  validates :user_id, presence: true

  #contentカラムのバリデーション
  validates :content, presence: true,
                        length: { maximum: 140 }
end
