class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :micropost, null: false, foreign_key: true

      t.timestamps
    end

    # favoritesテーブルにインデックスを追加
    # user_id と　micropost_id　のセットは一意であることを保証
    add_index :favorites, [:user_id, :micropost_id], unique: true
  end
end
