class Relationship < ApplicationRecord

  # followerメソッドの作成
  #followerカラムを、userモデル(user_id)に紐付け
  # 規約： "モデル名_id" => Follower_id のため、
  #  class_name: "User"を追加し、User_idを探しにいかせる
  belongs_to :follower, class_name: "User"

  # followedメソッドの作成
  #followedカラムを、userモデル(user_id)に紐付け
  belongs_to :followed, class_name: "User"

  validates :followed_id, presence: true
  validates :follower_id, presence: true
end
