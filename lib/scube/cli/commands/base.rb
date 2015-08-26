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
          @client = Client.new(env.base_uri, env.credentials)
          setup_arguments args
        end

      private

        attr_reader :client

        # FIXME: implement this correctly (arity errors)
        def setup_arguments args
          send :setup, *args if respond_to? :setup
        end

        def ask prompt
          print prompt
          input.noecho(&:gets).chomp.tap { puts }
        end
      end
    end
  end
end
