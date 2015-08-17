require 'benchmark'

module Scube
  module CLI
    module Commands
      class Ping
        REPORT_FORMAT = "`%d' response received after %d ms".freeze

        def initialize args, stdin: $stdin, stdout: $stdout
          fail ArgumentError if args.any?
          @stdin  = stdin
          @stdout = stdout
          @client = Client.new
        end

        def run
          response = nil
          time = Benchmark.realtime { response = @client.send ping_method }
          @stdout.puts REPORT_FORMAT % [response.status, time * 1000]
          @stdout.puts response.body if response.body.size > 0
        end

      private

        def ping_method
          :ping
        end
      end
    end
  end
end
