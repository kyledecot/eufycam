# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'eufycam/version'

Gem::Specification.new do |spec|
  spec.name          = 'eufycam'
  spec.version       = Eufycam::VERSION
  spec.authors       = ['Kyle Decot']
  spec.email         = ['kyle.decot@icloud.com']

  spec.summary       = 'Ruby interface for Eufycam'
  spec.description   = 'Ruby interface for Eufycam'
  spec.homepage      = 'https://github.com/kyledecot/eufycam'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'colorize', '~> 0.8'
  spec.add_runtime_dependency 'gli', '~> 2.19'
  spec.add_runtime_dependency 'lumberjack', '~> 1.2'
  spec.add_runtime_dependency 'terminal-table', '~> 1.8'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'pry', '~> 0.13'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.81'
  spec.add_development_dependency 'semantic', '~> 1.5'
  spec.add_development_dependency 'simplecov', '~> 0.18'
end
