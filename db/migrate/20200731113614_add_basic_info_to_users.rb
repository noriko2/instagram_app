class AddBasicInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    #usersテーブルにwebsite、introduction、phone、genderを追加
    add_column :users, :website, :string
    add_column :users, :introduction, :text
    add_column :users, :phone, :string
    add_column :users, :gender, :integer
  end
end
