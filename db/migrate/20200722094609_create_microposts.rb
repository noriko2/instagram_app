class CreateMicroposts < ActiveRecord::Migration[6.0]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
        #user_idとcreated_atカラムにインデックスを付与(リスト 13.3)(コラム 6.2.)。
        # --user_idに関連付けられたすべてのマイクロポストが作成時刻の逆順で取り出しやすくなる。
        # --user_idとcreated_atの両方を１つの配列に含めると、Active Recordは、両方のキーを同時に扱う複合キーインデックス（Multiple Key Index）作成する。
    add_index :microposts, [:user_id, :created_at]
  end
end
