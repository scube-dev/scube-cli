require 'faraday'

module Scube
  module CLI
    class Client
      # FIXME: extract as CLI option with default, pass to constructor
      SCUBE_BASE_URI = ENV['SCUBE_BASE_URI'].dup.freeze

      # def initialize base_uri
      #   @base_uri = base_uri
      # end
      #
      # def conn
      #   @conn ||= Faraday.new(url: @base_uri)
      # end

      def ping
        # FIXME: instanciated by the runner? or by each command who might give
        # in the configured uri in the env
        conn = Faraday.new(url: SCUBE_BASEURI)
        # FIXME: need auth
        conn.get 'ping'
      end
    end
  end
end
