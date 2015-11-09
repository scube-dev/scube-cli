module Scube
  module CLI
    module Commands
      class List < Base
        def setup type
          @type = type
        end

        def run
          client.send(type.to_sym).each do |record|
            p record
          end
        end

      private

        attr_reader :type
      end
    end
  end
end
