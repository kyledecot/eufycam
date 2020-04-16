# frozen_string_literal: true

require 'eufycam/version'

version = Eufycam::VERSION

desc "Release eufycam-#{version}.gem"
task :release, [:key] do |_task, args|
  args.with_defaults(key: 'rubygems')

  key = args.key.to_sym
  host = {
    rubygems: 'https://rubygems.org',
    github: 'https://rubygems.pkg.github.com/kyledecot'
  }.fetch(key)

  sh %(gem push --key=#{key} --host=#{host} eufycam-#{version}.gem)
end
