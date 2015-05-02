module Scube
  module CLI
    class Runner
      ArgumentError = Class.new(ArgumentError)

      USAGE = "Usage: #{File.basename $0} [options] command".freeze

      EX_USAGE    = 64
      EX_SOFTWARE = 70

      class << self
        def run arguments, stdout: $stdout, stderr: $stderr
          new(arguments).tap do |o|
            o.parse_arguments!
            o.run
          end
        rescue ArgumentError => e
          stderr.puts e
          exit EX_USAGE
        rescue RuntimeError => e
          stderr.puts "#{e.class.name}: #{e.message}"
          stderr.puts e.backtrace.map { |e| '  %s' % e }
          exit EX_SOFTWARE
        end
      end

      def initialize args, stdout: $stdout
        @arguments  = args
        @stdout     = stdout
        @env        = OpenStruct.new
      end

      def parse_arguments!
        option_parser.parse! @arguments
        fail ArgumentError, option_parser unless @command = @arguments.shift
      rescue OptionParser::InvalidOption => e
        fail ArgumentError, option_parser
      end

      def run
      end


      private

      def option_parser
        OptionParser.new do |opts|
          opts.banner = USAGE
          opts.separator ''
          opts.separator 'options:'

          opts.on '-v', '--verbose', 'enable verbose mode' do
            @env.verbose = true
          end

          opts.separator ''
          opts.on_tail '-h', '--help', 'print this message' do
            @stdout.print opts
            exit
          end
          opts.on_tail '-V', '--version', 'print version' do
            @stdout.puts VERSION
            exit
          end
        end
      end
    end
  end
end
