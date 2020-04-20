# frozen_string_literal: true

require 'eufycam/version'
require 'semantic'

namespace :version do
  desc 'Print current version'
  task :current do
    puts Eufycam::VERSION
  end

  desc 'Print next version'
  task :next do
    version = Semantic::Version.new(Eufycam::VERSION)

    puts version.increment!(:minor)
  end
end
