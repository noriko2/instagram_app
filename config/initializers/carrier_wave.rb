# CarrierWaveを通してS3を使うように修正

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    # キャッシュの保存期間
    config.fog_attributes = { 'Cache-Control': "max-age=#{365.day.to_i}" }
    # リンク直アクセスを弾く
    config.fog_public = false
    config.fog_credentials = {
      # Amazon S3用の設定
      provider: 'AWS',
      region:                 ENV['AWS_REGION'],
      aws_access_key_id:      ENV['AWS_ACCESS_KEY'],
      aws_secret_access_key:  ENV['AWS_SECRET_KEY']
    }
    config.fog_directory     =  ENV['AWS_BUCKET']
  end
end
