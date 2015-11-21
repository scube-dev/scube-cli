require 'aruba/api'
require 'aruba/cucumber/hooks'
require 'vcr'

require 'scube/cli'

class ArubaProgramWrapper
  def initialize argv, stdin = $stdin, stdout = $stdout, stderr = $stderr,
    kernel = Kernel
    @argv   = argv
    @stdin  = stdin
    @stdout = stdout
    @stderr = stderr
    @kernel = kernel
  end

  def execute!
    Scube::CLI::Runner.run(
      @argv.dup, stdin: @stdin, stdout: @stdout, stderr: @stderr
    )
  rescue SystemExit => e
    @kernel.exit e.status
  end
end


World(Aruba::Api)

Before do
  set_environment_variable 'HOME', expand_path(?.)
end

Before '@exec' do
  aruba.config.command_launcher = :spawn
end

Before '~@exec' do
  aruba.config.command_launcher = :in_process
  aruba.config.main_class       = ArubaProgramWrapper
end

VCR.configure do |c|
  c.cassette_library_dir = 'features/fixtures/vcr'
  c.debug_logger = $stderr if ENV.key? 'SCUBE_CLI_TEST_DEBUG'
  c.hook_into :faraday
  c.ignore_localhost = false
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
