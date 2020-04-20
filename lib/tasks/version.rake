# frozen_string_literal: true

require 'eufycam/version'
require 'semantic'

namespace :version do
  desc 'Print current version'
  task :current do
    puts Eufycam::VERSION
  end

  desc 'Increment version'
  task :increment do
    version = Semantic::Version.new(Eufycam::VERSION)
    path = File.expand_path(File.join('..', 'eufycam', 'version.rb'), __dir__)

    File.open(path, 'r+') do |file|
      contents = file.read
      contents.gsub!(Eufycam::VERSION, version.increment!(:minor).to_s)

      file.rewind
      file.write(contents)
    end
  end
end
