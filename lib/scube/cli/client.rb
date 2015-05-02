require 'faraday'

module Scube
  module CLI
    class Client
      # FIXME: extract as CLI option with default value
      SCUBE_BASE_URI = ENV['SCUBE_BASE_URI'].dup.freeze

      HEADERS = {
        'Accept'        => 'application/json',
        'Content-Type'  => 'application/json'
      }.freeze

      def initialize base_uri = SCUBE_BASE_URI
        @base_uri = base_uri
      end

      def conn
        @conn ||= Faraday.new(@base_uri, headers: HEADERS)
      end

      def ping
        conn.get 'ping'
      end
    end
  end
end
