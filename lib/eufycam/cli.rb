#!/usr/bin/env ruby
# frozen_string_literal: true

require 'gli'
require 'terminal-table'
require 'colorize'

module Eufycam
  class CLI
    extend GLI::App

    flag 'email',
         default_value: ENV['EUFYCAM_EMAIL'],
         arg_name: 'EMAIL'

    flag 'password',
         mask: true,
         default_value: ENV['EUFYCAM_PASSWORD'],
         arg_name: 'PASSWORD'

    command :devices do |devices|
      devices.command :timelapse do |timelapse|
        timelapse.flag 'device-name', arg_name: 'DEVICE_NAME'

        timelapse.action do |_global_options, options, _args|
          # client = Client.new(global_options.slice('username', 'password'))

          puts "capture a timelapse #{options['device-name']}"
        end
      end

      devices.command 'start-stream' do |start_stream|
        start_stream.action do |global_options, options, _args|
          client = Client.new(**global_options.slice(:email, :password))

          puts client.start_stream(
            device_name: options['device-name']
          ).to_json
        end
      end

      devices.command 'play' do |play|
        play.action do |global_options, options, _args|
          client = Client.new(**global_options.slice(:email, :password))

          url = client.start_stream(
            device_name: options['device-name']
          )['url']

          `ffplay -loglevel panic #{url}`
        end
      end

      devices.command 'list' do |list|
        list.action do |global_options, _options, _args|
          client = Client.new(**global_options.slice(:email, :password))

          results = client.list_devices

          puts results.to_json
        end
      end
    end
  end
end
