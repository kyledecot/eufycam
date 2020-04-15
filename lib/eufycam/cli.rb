#!/usr/bin/env ruby 

require 'gli'
require 'terminal-table'
require 'colorize'

module Eufycam 
  class CLI 
    extend GLI::App

    flag 'email',
      default_value: ENV["EUFYCAM_EMAIL"],
      arg_name: 'EMAIL'

    flag 'password',
      mask: true,
      default_value: ENV["EUFYCAM_PASSWORD"],
      arg_name: 'PASSWORD'


    command :devices do |devices|
        devices.command :timelapse do |timelapse|
        timelapse.flag 'device-name', arg_name: 'DEVICE_NAME'

        timelapse.action do |global_options, options, args|
					client = Client.new(global_options.slice('username', 'password'))

          puts "capture a timelapse #{options["device-name"]}"
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

      devices.command 'list' do |list|
        list.action do |global_options, options, _args|
					client = Client.new(**global_options.slice(:email, :password))

					client.list_devices.each do |device|
puts Terminal::Table.new(
							title: 'Device'.green,
			rows: device.slice("device_name", "device_sn", "station_sn").to_a
						)
					end 
        end 
      end
    end 
  end 
end 
