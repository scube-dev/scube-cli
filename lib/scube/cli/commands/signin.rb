require 'io/console'

module Scube
  module CLI
    module Commands
      class Signin
        def initialize args, stdin: $stdin, stdout: $stdout
          fail ArgumentError if args.size != 1
          @stdin  = stdin
          @stdout = stdout
          @client = Client.new
          @email  = args[0]
        end

        def run
          response = @client.session_post email: @email, password: ask_password
          case response.status
            when 200 then @stdout.puts response.body if response.body.size > 0
            when 404 then @stdout.puts 'Authentication failure'
          end
        end

      private

        def ask_password
          @stdout.print "Password for #@email@#{@client.base_uri}: "
          @stdin.noecho(&:gets).chomp.tap { puts }
        end
      end
    end
  end
end
