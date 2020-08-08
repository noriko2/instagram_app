class User < ApplicationRecord
  # ユーザーがマイクロポストを複数所有する（has_many）関連付け
  # has_many は、メソッドを作るための、メソッド
  # dependent: :destroy --ユーザーが削除されたときに、そのユーザーが投稿したマイクロポストも一緒に削除する
  has_many :microposts, dependent: :destroy

  has_many :favorites, dependent: :destroy

  # これを記載することで、 user.favorite_microposts でお気に入り投稿一覧が取得できる
  # favorite_micropostsにした理由は、上ですでにmicropostsという名前を使っているため。
  # sourceは「参照元のモデル」をさすオプション
  has_many :favorite_microposts, through: :favorites, source: :micropost

  has_many :comments, dependent: :destroy


  # 能動的関係に対して1対多（has_many）の関連付けを実装
  ## class_name: "Relationship"と記載しないと、デフォルト規約のActiveRelationshipモデルを探しに行ってしまう
    ## has_many :active_relationships　　　　　　　　　　　　　　　　　 =>  デフォルト class_name: "#{Model Name}s" =>ActiveRelationshipクラスへ
    ## has_many :active_relationships, class_name: "Relationship" =>　デフォルトのclass_name上書き 　　　　　　　　=>Relationshipクラスへ
  ##デフォルト　foreign_key: "user_id" <--class User < ApplicationRecordのuser
    ##foreign_key: "follower_id"とすることでデフォルトを上書き
  has_many :active_relationships, class_name: "Relationship",
                                 foreign_key: "follower_id",
                                   dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                   dependent: :destroy

  # Userモデルにfollowingメソッドを追加 【 リスト 14.8 】
  # userクラスのインスタンスに対し、active_relationshipsメソッドを実行し、そこで得られたrelationshipテーブルのインスタンスデータそれぞれに対し、
  # followedメソッドを実行し、その集合を返す 　　(followedメソッドは、modeld/relationshipで定義)
    # 結果、user.following.include?(other_user)や user.following.find(other_user)などが使えるようになる
  has_many :following, through: :active_relationships, source: :followed
        ## 上記がなくてもfollowingの集合は、手に入るが、followingメソッドを作った方が分かりやすいため、作成
        ## user = User.first
        ## user.active_relationships.first.followed---user.firstさんが、１番目にフォローした人の情報が表示される
        ## user.active_relationships.second.followed---user.firstさんが、2番目にフォローした人の情報が表示される
        ## user.active_relationships.map(&:followed)--user.firstさんが、フォローしている人、全員の情報が表示される
        ## 　　　　　(集合(map)に対して、それぞれfollowedメソッドを投げて(&:followed)、その集合を返す


  # Userモデルにfollowedメソッドを追加 【 リスト 14.12 】
  # (followerメソッドは、modeld/relationshipで定義)
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token

  #before_save { self.email = self.email.downcase }
  before_save {self.email.downcase!} #上記と同じ意味。破壊的メソッド

  #full_nameカラムのバリデーション
  validates :full_name, presence: true,
                     length: { maximum: 50}
  #user_nameカラムのバリデーション
  validates :user_name, presence: true,
                     length: { maximum: 50}

  #emailカラムのバリデーション
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                      length: {maximum: 255},
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: true
  # uniqueness: true  ‥‥‥‥メールアドレスの大文字小文字を区別して一意性を担保
  # uniqueness: { case_sensitive: false }‥メールアドレスの大文字小文字を区別しないで一意性を担保

  has_secure_password
    # allow_nilオプションは、対象の値がnilの場合にバリデーションをスキップする。
    # allow_nil: trueを付与することにより、ユーザー情報を編集する時は、password が nilでもバリデーションが通過できる。
    # password新規作成時は、has_secure_passwordで passwordがpresence:trueのバリデーションかかる。
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true


  validates :website, presence: true, length: { maximum: 255 }, allow_nil: true
  validates :introduction, presence: true, allow_nil: true
  validates :phone, presence: true, allow_nil: true
  validates :gender, presence: true, allow_nil: true

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


  # 自分の投稿と自分がフォローしているユーザーの投稿を返す
  def feed
    # relationshipsからfollower_idに自分のidを入れ、
    # それを使い、自分がフォロー中のユーザーのidを引っ張り、following_ids に代入
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    # DBへの問い合わせは１回となる
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: self.id)

    # 【NO.3】
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #                           following_ids: following_ids, user_id: self.id)
    # ?を使わずに【NO.2】をリファクタリング。 DBへの問い合わせは、２回

    # 【NO.2】
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, self.id)
    ##(?)には、following_ids（フォローしているidの集合）、?には self.id（自分のid）情報が入る(リスト 14.44)
    ## DBへの問い合わせが２回となる。

        # 【NO.1】 試作feedの定義(リスト 13.46)
        # SQL文に変数を代入する場合は常にエスケープする習慣を身につける。
          # 下記のコードで使われている疑問符は、セキュリティ上重要な役割をもつ。
          # 疑問符があることで、SQLクエリに代入する前にidがエスケープされるため、
          # SQLインジェクション（SQL Injection）呼ばれる深刻なセキュリティホールを避けることができる。
        #Micropost.where("user_id = ?", self.id)
  end

  # 自分の投稿を全て返す
  def my_feed
    Micropost.where("user_id = ?", self.id)
  end


  # ユーザーをフォローする 【リスト 14.10】
  def follow(other_user)
     #followingで取得したオブジェクトは、配列のように要素を追加できる
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    #followingで取得したオブジェクトは、配列のように要素を削除できる
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end


end
