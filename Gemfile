# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'geocoder', '~> 1.8'
gem 'grape', '~> 2.0'
gem 'grape_logging', '~> 1.8'
gem 'grape-swagger', '~> 2.0'
gem 'grape-swagger-entity', '~> 0.5.3'
gem 'prometheus-client', '~> 4.2'
gem 'puma', '~> 6.4'
gem 'rack-cors', '~> 2.0'
gem 'rake', '~> 13.2'

gem "cgi", ">= 0.3.1" # CVE-2021-41816

group :test, :development do
  gem 'minitest', '~> 5.23'
  gem 'rack-test', '~> 2.1'
  gem 'rubocop', '~> 1.64', require: false
end
