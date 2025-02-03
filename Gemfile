source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.2.4.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rubocop-performance'
#Frontend
gem 'bootstrap',              '~> 4.1.3'
gem 'font-awesome-sass',      '~> 5.3.1'
gem 'will_paginate',          '~> 3.1.1'
gem 'will_paginate-bootstrap4'
gem 'jquery-ui-rails'
gem 'jquery-rails'
gem 'momentjs-rails', '~> 2.9',  :github => 'derekprior/momentjs-rails'
gem 'bootstrap-datepicker-rails'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'chartkick'
gem 'jquery-datatables'
gem 'ajax-datatables-rails'
gem 'chosen-rails'
gem "select2-rails", '~> 4.0.2'
gem 'jquery_mask_rails', '~> 0.1.0'
gem 'pjax_rails'
gem 'toastr-rails'
gem 'summernote-rails'
gem 'cropper-rails'
gem 'jquery-mousewheel-rails'
gem 'jquery-dotdotdot-rails'
gem 'simple_calendar', '~> 2.0'
gem 'pace-rails'


#Backend
gem 'devise'
gem 'devise_invitable', '~> 2.0.0'
gem 'haml-rails',             '~> 1.0'
gem 'html2haml'
gem 'simple_form'
gem 'decent_exposure',        '3.0.0'
gem 'nested_form'
gem 'rails-jquery-autocomplete'
gem 'aws-sdk', '~> 3'
gem 'Afip'
gem 'groupdate'
gem 'faker', '~> 2.12.0'
#gem 'faker', github: 'stympy/faker'
gem 'cancancan', '~> 2.0'
gem 'pdf-reader'
gem 'virtus'
gem 'private_pub'
gem 'activerecord-import'
gem 'aasm'
gem 'rtesseract'
gem 'delayed_job_active_record'
gem 'ruby-anmat'
gem 'nested-hstore'
gem 'padron'
gem 'time_diff'
gem 'numbers_and_words'
gem 'reports_kit'

#Generador de PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'barby', '~> 0.6.6'
gem 'chunky_png'
gem 'rb-readline'

#Importar excel
gem 'roo'
gem 'roo-xls'
gem 'rubyzip', '>= 1.2.1'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'caxlsx_rails'
gem 'zip-zip'

#Dolar

gem 'dolar-bna'
gem "mechanize"
gem 'rubyntlm', '> 0.3.2'

# QR

gem 'rqrcode'
gem 'rqrcode_png'
#gem 'mimemagic', '~> 0.4.3'
gem 'rake'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'rubocop-faker'
  gem 'capybara'
  gem 'launchy'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem 'guard-rspec'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'geckodriver-helper'
  gem 'formulaic'
  gem 'shoulda-matchers'
  #gem 'pry-rails'
  gem 'capybara-select2'
  gem "letter_opener"
  gem 'rubocop', require: false

  # gem 'bullet'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #Styling conosle
  gem 'awesome_print'
  #Linter haml atom
  gem 'haml_lint', require: false
  gem 'capistrano3-delayed-job'
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-rbenv-install'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-unicorn-nginx'
  gem 'capistrano-postgresql'
  gem 'capistrano-safe-deploy-to'
  gem 'capistrano-ssh-doctor', git: 'https://github.com/capistrano-plugins/capistrano-ssh-doctor.git'
  gem 'capistrano-linked-files'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-logger'
  gem 'capistrano-rake', require: false
  gem 'ed25519'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


gem "unicorn", "~> 5.5"
gem "daemons"


gem 'paper_trail'
gem "audited", "~> 5.0"

# dias habiles
gem 'business_time'

# feriados
gem 'holidays'

#Update MTG
gem 'sassc', '~> 2.1.0'