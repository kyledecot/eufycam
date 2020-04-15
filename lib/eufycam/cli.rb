require 'gli'

module Eufycam 
  class CLI 
    extend GLI::App

    command :timelapse do |timelapse|
      timelapse.action do 
        puts "capture a timelapse"
      end 
    end
  end 
end 
