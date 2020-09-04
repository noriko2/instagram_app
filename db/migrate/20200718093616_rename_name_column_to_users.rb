class RenameNameColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    #カラム名の変更（ userカラムをuser_nameカラムに変更 ）
    rename_column :users, :name, :user_name
  end
end
