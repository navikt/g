# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'grape', '~> 1.5'
gem 'grape-swagger', '~> 1.3', git: 'https://github.com/ruby-grape/grape-swagger.git'
gem 'puma', '~> 5.0', '>= 5.0.2'

group :test, :development do
  gem 'minitest', '~> 5.14', '>= 5.14.2'
  gem 'rubocop', '~> 1.0', require: false
  gem 'rack-test', '~> 1.1'
end
