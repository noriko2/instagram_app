source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3'

#i18nを導入(英語から日本語対応に変更)
gem 'rails-i18n', '~> 6.0.0'

# fontawesome が使えるようにする
gem 'font-awesome-sass'

# Rails用のデバックツール
# gem 'pry-rails'

# Google Analytics (アクセス解析) を追加
gem 'google-analytics-rails', '~>1.1.1'

#画像処理用のgemを追加
 ## 1. $ brew install imagemagickをしてimagemagickをインストールする
 ## image_processing--どうやって加工するか、オプション（指示）を与えるためのgem
 ## mini_magick-------imagemagickをrailsで使えるようにするgem(画像を加工するためのgem)
gem 'image_processing', '~>1.12.2'
gem 'mini_magick', '~>4.9.5'

# carrierwaveの追加
gem 'carrierwave' , '~> 2.0'
# Ralisでfog、CarrierWave経由でAWS-S3に画像をアップロードさせる場合は、fogではなくfog-awsを使う
gem 'fog-aws'

# Active Storageバリデーション用のgemを追加
#gem 'active_storage_validations', '~>0.8.2'

# bcryptを追加(最先端のハッシュ関数。has_secure_passwordを使ってパスワードをハッシュ化するため)
gem 'bcrypt',         '~>3.1.13'
#Faker gemを追加( 実際にいそうなユーザー名を作成するgem )
gem 'faker',           '~>2.1.2'
#Bootstrapを追加
gem 'bootstrap-sass', '~>3.4.1'

#will_paginateを追加
gem 'will_paginate',           '~>3.1.8'
gem 'bootstrap-will_paginate', '~>1.0.0'

# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.4'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #エラー画面をわかりやすく成形してくれるgem
  #gem 'better_errors'
  #gem 'binding_of_caller'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'rails-controller-testing', '~> 1.0.4'
  gem 'minitest',                 '~>5.11.3'
  gem 'minitest-reporters',       '~>1.3.8'
end

group :production do
  gem 'pg', '1.1.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
