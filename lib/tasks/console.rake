# frozen_string_literal: true

require 'pry'
require 'eufycam'

desc 'Start a pry console'
task :console do
  Pry.start
end
