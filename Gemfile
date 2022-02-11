# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'grape', '~> 1.5'
gem 'grape-swagger', '~> 1.3', '>= 1.3.1'
gem 'prometheus-client', '~> 2.1'
gem 'puma', '~> 5.6'
gem 'rack-cors', '~> 1.1'

group :test, :development do
  gem 'minitest', '~> 5.14', '>= 5.14.2'
  gem 'rack-test', '~> 1.1'
  gem 'rubocop', '~> 1.0', require: false
end

gem 'geocoder', '~> 1.7'

gem 'grape_logging', '~> 1.8'
