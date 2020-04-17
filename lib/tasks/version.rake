# frozen_string_literal: true

require 'eufycam/version'

desc 'Print version'
task :version do |_task, _args|
  puts Eufycam::VERSION
end
