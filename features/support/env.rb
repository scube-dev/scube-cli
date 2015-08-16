require 'aruba/api'
require 'aruba/cucumber/hooks'

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

Before('@exec') do
  aruba.config.command_launcher = :spawn
end

Before('~@exec') do
  aruba.config.command_launcher = :in_process
  aruba.config.main_class       = ArubaProgramWrapper
end
