begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require "rake/testtask"

require "vite_ruby"
ViteRuby.install_tasks
ViteRuby.config.root # Ensure the engine is set as the root.

Rake::TestTask.new(:test) do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*spec.rb"
  t.verbose = false
end

task default: :test

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)

load "rails/tasks/engine.rake"
load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"
