module Scube
  module CLI
    class Env
      RC_PATH = '~/.scuberc.rb'.freeze

      extend Forwardable
      def_delegator :@output, :print
      def_delegator :@output, :puts

      attr_reader :input, :output

      def initialize input, output
        @input    = input
        @output   = output
        @rc_path  = RC_PATH
      end
    end
  end
end
