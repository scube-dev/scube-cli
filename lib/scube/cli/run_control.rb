require 'yaml'

module Scube
  module CLI
    class RunControl
      RC_PATH = '~/.scuberc.yaml'.freeze

      class << self
        def load file_path = RC_PATH
          symbolize_keys YAML.load_file(File.expand_path(file_path))
        rescue Errno::ENOENT
          {}
        end

      private

        def symbolize_keys hash
          case hash
          when Hash
            Hash[hash.map do |k, v|
              [k.respond_to?(:to_sym) ? k.to_sym : k, symbolize_keys(v)]
            end]
          when Enumerable
            hash.map { |v| symbolize_keys v }
          else
            hash
          end
        end
      end
    end
  end
end
