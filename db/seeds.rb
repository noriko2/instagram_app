# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

## db/seeds.rb(seedデータ)--データベースに投入する初期データのこと


# 管理者（管理者権限を持つユーザー）を1人作成する
User.create!(full_name: "Kanri Sya",
             user_name: "kanrisya_123",
                 email: "kanrisya@example.com",
              password:             "foobar",
              password_confirmation: "foobar",
                 admin: true)
