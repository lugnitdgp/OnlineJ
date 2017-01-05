source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Adapter for mongodb
gem 'mongoid'
# gem 'Moped' and 'BSON'
gem "moped"
gem "bson"
# 'rubocop' for refactoring
gem 'rubocop', require: false
# gem 'rails-admin' for admin
gem 'rails_admin'
# use gem 'sidekiq' for workers to judge process
gem 'sidekiq'
# various options for gem sidekiq
gem 'sinatra', :require => nil
gem 'slim'
gem 'sidetiq'
gem 'sidekiq-status'
gem 'sidekiq-failures'
gem 'sidekiq-unique-jobs'
# gem "mongoid-paperclip" for using paperclip with mongodb
gem "mongoid-paperclip"
# gem 'kaminari' for pagination
gem 'kaminari'
gem 'bootstrap-kaminari-views'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# gem 'snappconfig' for global config
gem 'snappconfig'
# gem 'codemirror' for code editor
gem 'codemirror-rails'
# 'bootstrap and material for rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Authentication
gem 'devise'
gem 'omniauth'
# github authentication
gem 'omniauth-github'
# facebook authentication
gem 'omniauth-facebook'
# google authentication
gem 'omniauth-google-oauth2'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use rspec-rails for test
  gem 'rspec-rails'
  # replaces default fixtures
  gem 'factory_girl_rails'
end

group :test do
  gem 'faker'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'rails-controller-testing'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
