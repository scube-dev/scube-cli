require 'io/console'

module Scube
  module CLI
    module Commands
      class Signin < Base
        def setup email
          @email = email
        end

        def run
          response = client.session_post email: @email, password: ask_password
          case response.status
            when 200 then puts response.body if response.body.size > 0
            when 404 then puts 'Authentication failure'
          end
        end

      private

        def ask_password
          ask "Password for #@email@#{client.base_uri}: "
        end
      end
    end
  end
end
