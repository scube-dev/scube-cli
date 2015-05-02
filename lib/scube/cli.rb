require 'optparse'
require 'ostruct'

require 'scube/cli/client'
require 'scube/cli/commands'
require 'scube/cli/commands/import'
require 'scube/cli/runner'
require 'scube/cli/version'

module Scube
  module CLI
    Error         = Class.new(StandardError)
    RuntimeError  = Class.new(RuntimeError)
  end
end
