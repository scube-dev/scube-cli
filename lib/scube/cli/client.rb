require 'faraday'
require 'faraday_middleware'

module Scube
  module CLI
    class Client
      AuthenticationError = Class.new(RuntimeError)
      APIInternalError    = Class.new(RuntimeError)

      HEADERS = {
        'Accept' => 'application/json'
      }.freeze

      attr_reader :base_uri

      def initialize base_uri, credentials, logger: nil
        @base_uri     = base_uri
        @credentials  = credentials
        @logger       = logger
      end

      def conn
        @conn ||= Faraday.new(@base_uri) do |c|
          c.request :multipart
          c.request :url_encoded
          c.request :json
          c.authorization :Token,
            token: @credentials
          c.response :logger, @logger if @logger
          c.response :json
          c.adapter Faraday.default_adapter
        end.tap do |c|
          HEADERS.each do |k, v|
            c.headers[k] = v
          end
        end
      end

      def ping
        get 'ping'
      end

      def ping_auth
        get 'ping/auth'
      end

      def session_post **params
        post 'sessions', session: params
      end

      def sound? digest
        head("sounds/#{digest}").success?
      end

      def sound_post path
        post 'sounds', sound: {
          file: Faraday::UploadIO.new(path.to_s, 'audio/mpeg')
        }
      end

      def tracks
        get('tracks').body['tracks']
      end

      def track_post name, sound_path
        post 'tracks', track: {
          name: name,
          file: Faraday::UploadIO.new(sound_path.to_s, 'audio/mpeg')
        }
      end

    private

      %i[head get post put delete].each do |meth|
        define_method meth do |path, **params|
          conn.send(meth, path, params).tap do |response|
            case response.status
              when 401 then fail AuthenticationError
              when 500 then fail APIInternalError
            end
          end
        end
      end
    end
  end
end
