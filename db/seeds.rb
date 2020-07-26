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

#追加のユーザーをまとめて作成する
30.times do |n|
  full_name = Faker::Name.name
  user_name = "#{full_name}_123"
  email = "example-#{n+1}@sample.org"
  password = "password"
    #create!は基本的にcreateメソッドと同じものだが、ユーザーが無効な場合にfalseを返すのではなく例外を発生させる（6.1.4）。
    # --見過ごしやすいエラーを回避できるので、デバッグが容易になる
  User.create!(full_name: full_name,
               user_name: user_name,
                   email: email,
                password: password,
                password_confirmation: password)
end


# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
10.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end
