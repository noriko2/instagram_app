class User < ApplicationRecord
  attr_accessor :remember_token

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

  #ランダムなトークンを返す
  def User.new_token
    # SecureRandomモジュールにあるurlsafe_base64メソッドを使用
    #urlsafe_base64メソッド‥‥A–Z、a–z、0–9、"-"、"_"のいずれかの文字（64種類）からなる長さ22のランダムな文字列を返す
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
      # バグに対応（ リスト 9.19 ）
    return false if remember_digest.nil? # remember_digestがnilの場合は、ここで処理が終了。BCrypt:‥‥は実行されない。
      # Cryptはモジュール。Password はその中にあるクラス.
      # remember_tokenは、attr_accessor :remember_tokenで定義したアクセサとは異なる。今回、is_password?の引数はメソッド内のローカル変数を参照。
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する( remember_digestの値を nil にする)
  def forget
    self.update_attribute(:remember_digest, nil)
  end
end
