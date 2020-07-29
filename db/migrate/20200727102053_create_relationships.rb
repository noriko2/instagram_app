class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end

    # relationshipsテーブルにインデックスを追加
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
      # 複合キーインデックス
      ## follower_idとfollowed_idの組み合わせが必ずユニークであることを保証。
      ## これにより、あるユーザーが同じユーザーを2回以上フォローすることを防ぐ。
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
