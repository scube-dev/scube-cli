require 'scube/cli/commands/ping'

module Scube
  module CLI
    module Commands
      class PingAuth < Ping
      private

        def ping_method
          :ping_auth
        end
      end
    end
  end
end
