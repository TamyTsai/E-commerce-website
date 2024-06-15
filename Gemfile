source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
gem 'image_processing', '~> 1.2'
# 做縮圖處理用的

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# devise套件 會員系統
gem 'devise', '~> 4.9', '>= 4.9.4'
# devise套件 對 OAuth開放授權 的實作 這裡對google開放授權
gem 'omniauth-google-oauth2', '~> 1.1', '>= 1.1.2'
# figaro 用來設定全域環境變數（放到config > application.yml） 並讓該檔不受git追蹤
gem 'figaro', '~> 1.2'
# $ bundle
# $ figaro install
# paranoia 軟刪除
gem 'paranoia', '~> 2.6', '>= 2.6.3'
# friendly_id 幫你長出好看的網址
gem 'friendly_id', '~> 5.5', '>= 5.5.1'
# $ rails g migration AddSlugToUsers slug:uniq 不用執行這行，因為我們的products資料表本來就有建像slug的欄位（code商品代碼）
# $ rails generate friendly_id
#       create  db/migrate/20240611033654_create_friendly_id_slugs.rb
#       create  config/initializers/friendly_id.rb
# pagy 分頁套件
gem 'pagy', '~> 6.2'
# acts_as_list 紀錄position
gem 'acts_as_list', '~> 1.2', '>= 1.2.1'
# faraday 用來打API
gem 'faraday', '~> 2.7', '>= 2.7.12'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  gem 'foreman', '~> 0.87.1'
  gem 'hirb-unicode', '~> 0.0.5'
  # rspec 用來寫測試
  # rspec rails 特化給rails用的rspec套件 用來寫測試的本體
  # gem 'rspec-rails', '~> 4.0'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.2'
  # factory bot rails 輔助產生測試資料用的 Gem
  # gem 'factory_bot_rails', '~> 5.1', '>= 5.1.1'
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  # facker 輔助產生測試資料用的 Gem
  # gem 'faker', '~> 2.11'
  gem 'faker', '~> 3.4', '>= 3.4.1'
  gem 'pry-rails', '~> 0.3.9'
  # 這些 Gem 因為 僅會在 開發 及測試 階段 會使用到，所以建議放到 development 以及 test 的 Gem 群組裡
  # DatabaseCleaner 用來在測試前 自動清資料庫
  gem 'database_cleaner', '~> 2.0', '>= 2.0.2'
end
