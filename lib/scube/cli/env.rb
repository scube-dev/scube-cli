module Scube
  module CLI
    class Env
      DEFAULTS  = {
        base_uri:     'http://localhost:3000/api'.freeze,
        credentials:  nil
      }.freeze

      extend Forwardable
      def_delegator :@output, :print
      def_delegator :@output, :puts

      attr_reader :input, :output, :base_uri, :credentials

      def initialize input, output
        @input    = input
        @output   = output
        merge! DEFAULTS
      end

      def merge! other
        other.each do |k, v|
          instance_variable_set "@#{k}", v
        end
      end
    end
  end
end
