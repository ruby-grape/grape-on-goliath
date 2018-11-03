require 'rubygems'
require 'bundler/setup'

require 'rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path('config/environment', __dir__)
end

task routes: :environment do
  Acme::API.routes.each do |route|
    p route
  end
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: %i[rubocop spec]
