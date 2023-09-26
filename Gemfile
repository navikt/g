# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'geocoder', '~> 1.8'
gem 'grape', '~> 1.8'
gem 'grape_logging', '~> 1.8'
gem 'grape-swagger', '~> 1.6'
gem 'prometheus-client', '~> 4.2'
gem 'puma', '~> 6.4'
gem 'rack-cors', '~> 2.0'
gem 'rake', '~> 13.0'

group :test, :development do
  gem 'minitest', '~> 5.20'
  gem 'rack-test', '~> 2.1'
  gem 'rubocop', '~> 1.56', require: false
end
