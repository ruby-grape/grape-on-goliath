source 'https://rubygems.org'

gem 'goliath', ENV.fetch('GOLIATH_VERSION', '~> 1.0'), require: 'goliath/api'
gem 'grape', '~> 1.8'
gem 'http_parser.rb', ENV.fetch('HTTP_PARSER_VERSION', '>= 0')
gem 'rack', '~> 1.6'
gem 'rack-contrib', '~> 1.4.0'

group :development do
  gem 'rake'
  gem 'rubocop'
end

group :test do
  gem 'em-http-request', ENV.fetch('HTTP_CLIENT_VERSION', '>= 0')
  gem 'json', '< 3' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('3.2')
  gem 'rack-test'
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
end
