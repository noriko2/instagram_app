class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps #← created_at と updated_atの２つのマジックカラムを追加する
    end
  end
end
