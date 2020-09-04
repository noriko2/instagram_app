class AddPasswordDigestToUsers < ActiveRecord::Migration[6.0]
  def change
    # has_secure_password機能を使えるようにするには、1つだけ条件があり、
    # モデル内にpassword_digestカラムがあること。
    # そのため、usersテーブルに、password_digestカラムを追加
    add_column :users, :password_digest, :string
  end
end
