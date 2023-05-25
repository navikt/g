# frozen_string_literal: true

require 'rake/testtask'

task default: :test

desc 'Run tests'
Rake::TestTask.new do |t|
  ENV['GRUNNBELØP'] = './grunnbeløp.json'
  t.libs << 'test'
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end
