# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

## db/seeds.rb(seedデータ)--データベースに投入する初期データのこと


# 管理者（管理者権限を持つユーザー）を1人作成
User.create!(full_name: "Kanri Sya",
             user_name: "kanrisya_123",
                 email: "kanrisya@example.com",
              password:             "foobar",
              password_confirmation: "foobar",
                 admin: true,
          introduction: "管理人です。よろしくお願いします。",
               website: "https://www.sample.com",
                 phone: "09000000000",
                gender: 2)


# 一般ユーザーを1人作成
User.create!(full_name: "Wan wanko",
             user_name: "wanko_123",
                 email: "wanko@example.com",
              password:             "foobar",
              password_confirmation: "foobar",
          introduction: "ワンコです。美しい毛並みが自慢です。",
               website: "https://www.wanko_sample.com",
                 phone: "09011111111",
                gender: 1)


#追加のユーザーをまとめて作成
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


# wankoのマイクロポストを生成
user = User.find_by(user_name: "wanko_123")
content = "おいしい飲み物見つけた！"
image = open("./app/assets/images/sample_image.jpeg")
user.microposts.create!(content: content, image: image)



# ユーザーの一部を対象にマイクロポストを生成する
users = User.order(:created_at).take(6)
10.times do
  content = Faker::Lorem.sentence(word_count: 5)
  image = open("./app/assets/images/sample_image.jpeg")
  users.each { |user| user.microposts.create!(content: content, image: image) }
  #image = open "#{Rails.root}/test/fixtures/kitten.jpg"
  #users.each { |user| user.microposts.create!(content: content, image: image)}
end


# 以下のリレーションシップを作成する
users = User.all
user  = users.first
  #最初のユーザーにユーザー3からユーザー21までをフォローさせる
following = users[2..20]
  #ユーザー4からユーザー11に最初のユーザーをフォローさせる
followers = users[3..10]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
