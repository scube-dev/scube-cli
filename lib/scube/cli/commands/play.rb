module Scube
  module CLI
    module Commands
      class Play < Base
        def setup type, id
          @type = type
          @id   = id
        end

        def run
          client.sound_file id do |file|
            system "mplayer #{file.path}"
          end
        end

      private

        attr_reader :type, :id
      end
    end
  end
end
