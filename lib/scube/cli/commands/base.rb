module Scube
  module CLI
    module Commands
      class Base
        extend Forwardable
        def_delegator :@env, :input
        def_delegator :@env, :print
        def_delegator :@env, :puts

        def initialize env, args
          @env    = env
          @client = build_client env
          setup_arguments args
        end

      private

        attr_reader :client

        def build_client env
          Client.new(env.base_uri, env.credentials, logger: env.logger)
        end

        def setup_arguments args
          send :setup, *args if respond_to? :setup
        rescue ::ArgumentError
          fail ArgumentError
        end

        def ask prompt
          print prompt
          input.noecho(&:gets).chomp.tap { puts }
        end
      end
    end
  end
end
