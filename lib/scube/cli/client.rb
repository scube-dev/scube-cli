require 'faraday'
require 'faraday_middleware'

module Scube
  module CLI
    class Client
      AuthenticationError = Class.new(RuntimeError)
      APIInternalError    = Class.new(RuntimeError)

      # FIXME: extract as CLI option with default value
      SCUBE_BASE_URI = ENV['SCUBE_BASE_URI'].dup.freeze
      # FIXME: extract as CLI option with default value
      TOKEN_PATH = '~/.scube/credentials'.freeze

      HEADERS = {
        'Accept' => 'application/json'
      }.freeze

      def initialize base_uri = SCUBE_BASE_URI
        @base_uri = base_uri
      end

      def conn
        @conn ||= Faraday.new(@base_uri) do |c|
          c.request :multipart
          c.request :url_encoded
          c.request :json
          c.authorization :Token,
            token: File.read(File.expand_path(TOKEN_PATH)).chomp
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

      def sound? digest
        head("sounds/#{digest}").success?
      end

      def sound_post path
        post 'sounds', sound: {
          file: Faraday::UploadIO.new(path.to_s, 'audio/mpeg')
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
