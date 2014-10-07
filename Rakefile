require "bundler/gem_tasks"
require 'bundler'
require 'rspec/core/rake_task'
require 'date'

Bundler::GemHelper.install_tasks

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  # Put spec opts in a file named .rspec in root
end
