require 'faraday'
require 'faraday_middleware'
require 'tempfile'

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
          c.response :json, content_type: /\bjson\z/
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

      def playlists
        get('playlists').body['playlists']
      end

      def sound? digest
        head("sounds/#{digest}").success?
      end

      def sound_file id
        sound_content = get("sounds/#{id}").body
        Tempfile.create(File.basename($0 + ?_)) do |f|
          f.write sound_content
          f.flush
          yield f
        end
      end

      def sound_post path
        post 'sounds', sound: {
          file: Faraday::UploadIO.new(path.to_s, 'audio/mpeg')
        }
      end

      def tracks
        get('tracks').body['tracks']
      end

      def track_post sound_path, **attributes
        post 'tracks', track: {
          file: Faraday::UploadIO.new(sound_path.to_s, 'audio/mpeg')
        }.merge(attributes)
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
