class User < ApplicationRecord
  #before_save { self.email = self.email.downcase }
  before_save {self.email.downcase!} #上記と同じ意味。破壊的メソッド

  #nameカラムのバリデーション
  validates :name, presence: true,
                     length: { maximum: 50}

  #emailカラムのバリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                      length: {maximum: 255},
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true
  #uniqueness: true  ‥‥‥‥メールアドレスの大文字小文字を区別して一意性を担保
  #uniqueness: { case_sensitive: false }‥メールアドレスの大文字小文字を区別しないで一意性を担保

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}


  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    #コストパラメータをテスト中は最小にし、本番環境ではしっかりと計算する
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
