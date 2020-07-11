class AddIndexToUsersEmail < ActiveRecord::Migration[6.0]
  def change
    #usersテーブルのemailカラムにインデックスを追加
    #インデックスは一意性を強制しないが、オプションでunique: trueを指定することで強制
    add_index :users, :email, unique: true
  end
end
