require 'io/console'

module Scube
  module CLI
    module Commands
      class Signin
        def initialize args
          fail ArgumentError if args.size != 1
          @client = Client.new
          @email  = args[0]
        end

        def run
          response = @client.session_post email: @email, password: ask_password
          case response.status
            when 200 then puts response.body if response.body.size > 0
            when 404 then puts 'Authentication failure'
          end
        end

      private

        # FIXME: standard input should be handled by the CLI and a command base
        # class.
        def ask_password
          print "Password for #@email@#{@client.base_uri}: "
          $stdin.noecho(&:gets).chomp.tap { puts }
        end
      end
    end
  end
end
