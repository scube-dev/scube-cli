module Scube
  module CLI
    module Commands
      class List < Base
        def setup type, *query
          @type   = type
          @query  = query
        end

        def run
          client.tracks.each do |track|
            p track
          end
        end

      private

        attr_reader :type, :query
      end
    end
  end
end
