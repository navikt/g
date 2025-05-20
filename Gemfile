# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'cgi', '>= 0.3.1' # CVE-2021-41816
gem 'grape', '~> 2.3'
gem 'grape_logging', '~> 1.8'
gem 'grape-swagger', '~> 2.1'
gem 'grape-swagger-entity', '~> 0.6.2'
gem 'prometheus-client', '~> 4.2'
gem 'puma', '~> 6.6'
gem 'rack-cors', '~> 3.0'
gem 'rake', '~> 13.2'

group :test, :development do
  gem 'minitest', '~> 5.25'
  gem 'rack-test', '~> 2.2'
  gem 'rubocop', '~> 1.75', require: false
  gem 'rubocop-minitest', '~> 0.38.0', require: false
  gem 'rubocop-rake', '~> 0.7.1', require: false
end
