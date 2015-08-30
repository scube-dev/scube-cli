require 'logger'

module Scube
  module CLI
    class Env
      DEFAULTS  = {
        debug:        false,
        base_uri:     'http://localhost:3000/api'.freeze,
        credentials:  nil
      }.freeze

      LOGGER_LEVEL          = Logger::WARN
      LOGGER_LEVEL_DEBUG    = Logger::DEBUG

      extend Forwardable
      def_delegator :@output, :print
      def_delegator :@output, :puts

      attr_reader :input, :output, :base_uri, :credentials
      attr_accessor :debug

      def initialize input, output
        @input    = input
        @output   = output
        merge! DEFAULTS
      end

      def debug?
        !!@debug
      end

      def merge! other
        other.each do |k, v|
          instance_variable_set "@#{k}", v
        end
      end

      def logger
        @logger ||= Logger.new(@output).tap do |o|
          o.level = debug? ? LOGGER_LEVEL_DEBUG : LOGGER_LEVEL
          o.formatter = LoggerFormatter.new
        end
      end

    private

      class LoggerFormatter
        FORMAT_STR = "%s.%03i %s: %s\n".freeze

        def call severity, datetime, _progname, message
          FORMAT_STR % [
            datetime.strftime('%FT%T'),
            datetime.usec / 1000,
            severity[0..0],
            message
          ]
        end
      end
    end
  end
end
