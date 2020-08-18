class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost

  has_many :notifications, dependent: :destroy

  #commentカラムのバリデーション
  validates :comment, presence: true,
                        length: { maximum: 140 }


  #default_scopeでFavoriteを順序付ける(デフォルトの古い順から最新順に変更)
  default_scope -> { order(created_at: :desc) }


  validates :user_id, presence: true
  validates :micropost_id, presence: true

end
