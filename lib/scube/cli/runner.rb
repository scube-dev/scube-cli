module Scube
  module CLI
    class Runner
      ArgumentError = Class.new(ArgumentError)

      USAGE = "Usage: #{File.basename $0} [options] command".freeze

      EX_USAGE    = 64
      EX_SOFTWARE = 70

      COMMANDS = {
        import:       ['Import',    'Import local sound file into scube'],
        list:         ['List',      'List resources'],
        ping:         ['Ping',      'Ping scube server'],
        'ping:auth':  ['PingAuth',  'Ping scube server (authenticated)'],
        play:         ['Play',      'Play given track'],
        signin:       ['Signin',    'Signin and get authentication token']
      }.freeze

      class << self
        def run arguments, stdin: $stdin, stdout: $stdout, stderr: $stderr
          new(arguments, stdin: stdin, stdout: stdout).tap do |o|
            o.load_run_control!
            o.parse_arguments!
            o.run!
          end
        rescue ArgumentError => e
          stderr.puts e
          exit EX_USAGE
        rescue StandardError => e
          stderr.puts "#{e.class.name}: #{e.message}"
          stderr.puts e.backtrace.map { |l| '  %s' % l }
          exit EX_SOFTWARE
        end
      end

      def initialize args, stdin: $stdin, stdout: $stdout
        @arguments  = args
        @stdin      = stdin
        @stdout     = stdout
        @env        = Env.new(stdin, stdout)
      end

      def load_run_control!
        # FIXME: maybe we can use a #merge method and make input/output some
        # key/value pairs as a hash
        @env.merge! RunControl.load
      end

      def parse_arguments!
        option_parser.parse! @arguments
        fail ArgumentError, option_parser unless @arguments.any?
        @command = @arguments.shift.to_sym
      rescue OptionParser::InvalidOption
        raise ArgumentError, option_parser
      end

      def run!
        fail ArgumentError, option_parser unless COMMANDS.keys.include? @command
        command = Commands.const_get COMMANDS[@command].first
        command.new(@env, @arguments).run
      rescue Commands::ArgumentError
        raise ArgumentError, option_parser
      end

    private

      def option_parser
        OptionParser.new do |opts|
          opts.banner = USAGE
          opts.separator ''
          opts.separator 'options:'

          opts.on '-d', '--debug', 'enable debug mode' do
            @env.debug = true
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
