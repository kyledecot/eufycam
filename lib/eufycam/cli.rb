#!/usr/bin/env ruby
# frozen_string_literal: true

require 'gli'
require 'shellwords'
require 'terminal-table'
require 'rainbow'
require 'eufycam'
require 'lumberjack'

module Eufycam
  class CLI
    extend GLI::App

    LOGGER = Lumberjack::Logger.new(STDOUT)

    flag 'email',
         default_value: ENV['EUFYCAM_EMAIL'],
         arg_name: 'EMAIL'

    flag 'password',
         mask: true,
         default_value: ENV['EUFYCAM_PASSWORD'],
         arg_name: 'PASSWORD'

    command :devices do |devices|
      devices.command 'timelapse' do |timelapse|
        timelapse.flag 'device-name', arg_name: 'DEVICE_NAME', desc: 'Device name'
        timelapse.flag 'interval', arg_name: 'INTERVAL', default_value: 60, desc: 'Interval in seconds', type: Integer

        timelapse.action do |global_options, options, _args|
          client = Client.new(global_options.slice(:email, :password))

          LOGGER.info("Device Name: #{options['device-name']}")

          url = client.start_stream(
            device_name: options['device-name']
          )['url']

          loop do
            command = "ffmpeg -loglevel quiet -i \"#{url}\" -vframes 1 eufycam-#{Time.now.to_i}.jpg"

            LOGGER.info("COMMAND: #{command}")

            `#{command}`

            print '.'
            sleep options[:interval]
          end
        end
      end

      devices.command 'start-stream' do |start_stream|
        start_stream.flag 'device-name', arg_name: 'DEVICE_NAME'

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
