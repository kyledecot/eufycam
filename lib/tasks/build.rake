# frozen_string_literal: true

require 'eufycam/version'

desc "Build eufycam-#{Eufycam::VERSION}.gem"
task :build do
  sh %(gem build eufycam.gemspec)
end
