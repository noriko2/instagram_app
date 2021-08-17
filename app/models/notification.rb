class Notification < ApplicationRecord
  default_scope -> { self.order(created_at: :desc) }

  # optional: trueは、nilを許容する。(belongs_toで紐付ける場合はnilが許可されないため)
  # railsではbelongs_toのつけられたカラムには自動的にallow_nil: falseが付与される。
  # フォロー通知ではmicropost_idは関与しないためnilとなるので、このオプションをつけないとフォロー通知が有効にならない
  belongs_to :micropost, optional: true
  belongs_to :comment, optional: true

  # visitorメソッドの作成
  #visitor_idカラムを、userモデル(user_id)に紐付け
  #デフォルト class_name: Visitorモデルを探しにいくのを Userモデルへ上書き
  #デフォルト foreign_key: "notification_id"を "visitor_id" に上書き
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

end
