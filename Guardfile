# frozen_string_literal: true

require 'guard/rspec/dsl'

guard :rspec, cmd: 'bundle exec rspec' do
  dsl = Guard::RSpec::Dsl.new(self)
  rspec = dsl.rspec
  ruby = dsl.ruby

  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  dsl.watch_spec_files_for(ruby.lib_files)
end
