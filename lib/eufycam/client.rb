# frozen_string_literal: true

require 'uri'
require 'json'
require 'net/http'

module Eufycam
  class Client
    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def post(path, access_token, body = nil)
      uri = URI("https://mysecurity.eufylife.com/api/v1/#{path}")
      
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        yield http.request(request(path, access_token, body))
      end
    end

    def request(path, auth_token, body = nil)
      uri = URI("https://mysecurity.eufylife.com/api/v1/#{path}")

      Net::HTTP::Post.new(uri).tap do |post|
        post.body = body.to_json
        post['x-auth-token'] = auth_token unless auth_token.nil?
      end
    end

    def generate_auth_token
      post('passport/login', nil, {
             email: ENV.fetch('EUFYCAM_EMAIL'),
             password: ENV.fetch('EUFYCAM_PASSWORD')
           }) do |response|
        JSON.parse(response.body)['data']['auth_token']
      end
    end

    def list_devices(auth_token = generate_auth_token)
      post('app/get_devs_list', auth_token) do |response|
        JSON.parse(response.body)['data']
      end
    end

    def start_stream(device_name:)
      auth_token = generate_auth_token
      body = list_devices(auth_token)
             .detect { |d| d['device_name'] == device_name }
             .slice('station_sn', 'device_sn')

      post(
        'web/equipment/start_stream',
        auth_token,
        body
      ) do |response|
        JSON.parse(response.body)['data']
      end
    end

    def capture_image(url, filename)
      system('ffmpeg', '-hide_banner', '-loglevel', 'panic', '-i', url.to_s, '-r', '5', filename.to_s)
    end

    def timelapse(device_name, directory)
      url = start_stream(device_name)

      loop do
        capture_image(url, File.expand_path("#{directory}/#{Time.now.to_i}.png"))
        print '.'
        sleep(1)
      end
    end
  end
end
