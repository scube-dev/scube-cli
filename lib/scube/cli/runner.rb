module Scube
  module CLI
    class Runner
      ArgumentError = Class.new(ArgumentError)

      USAGE = "Usage: #{File.basename $0} [options] command".freeze

      EX_USAGE    = 64
      EX_SOFTWARE = 70

      COMMANDS = {
        import:       ['Import',    'Import local sound file into scube'],
        ping:         ['Ping',      'Ping scube server'],
        'ping:auth':  ['PingAuth',  'Ping scube server (authenticated)'],
        signin:       ['Signin',    'Signin and get authentication token']
      }.freeze

      class << self
        def run arguments, stdin: $stdin, stdout: $stdout, stderr: $stderr
          new(arguments, stdin: stdin, stdout: stdout).tap do |o|
            o.parse_arguments!
            o.run
          end
        rescue ArgumentError => e
          stderr.puts e
          exit EX_USAGE
        rescue RuntimeError => e
          stderr.puts "#{e.class.name}: #{e.message}"
          stderr.puts e.backtrace.map { |l| '  %s' % l }
          exit EX_SOFTWARE
        end
      end

      def initialize args, stdin: $stdin, stdout: $stdout
        @arguments  = args
        @stdin      = stdin
        @stdout     = stdout
        @env        = OpenStruct.new
      end

      def parse_arguments!
        option_parser.parse! @arguments
        fail ArgumentError, option_parser unless @arguments.any?
        @command = @arguments.shift.to_sym
      rescue OptionParser::InvalidOption
        raise ArgumentError, option_parser
      end

      def run
        fail ArgumentError, option_parser unless COMMANDS.keys.include? @command
        command = Commands.const_get COMMANDS[@command].first
        command.new(@arguments, stdin: @stdin, stdout: @stdout).run
      rescue Commands::ArgumentError
        raise ArgumentError, option_parser
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
          opts.on '-h', '--help', 'print this message' do
            @stdout.print opts
            exit
          end
          opts.on '-V', '--version', 'print version' do
            @stdout.puts VERSION
            exit
          end

          opts.separator ''
          opts.separator 'commands:'
          COMMANDS.each do |name, meta|
            desc = meta.last
            opts.separator '  %-8s %s' % [name, desc]
          end
        end
      end
    end
  end
end
