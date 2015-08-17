require File.expand_path('../lib/scube/cli/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'scube-cli'
  s.version     = Scube::CLI::VERSION.dup
  s.summary     = 'CLI client for Scube'
  s.description = s.name
  s.license     = 'BSD-3-Clause'
  s.homepage    = 'https://rubygems.org/gems/scube-cli'

  s.authors     = 'Thibault Jouan'
  s.email       = 'tj@a13.fr'

  s.files       = `git ls-files lib`.split $/
  s.executable  = 'scube'
  s.extra_rdoc_files = %w[README.md]

  s.add_dependency 'faraday', '~> 0.9'
  s.add_dependency 'faraday_middleware', '~> 0.9'

  s.add_development_dependency 'aruba',     '~> 0.8'
  s.add_development_dependency 'cucumber',  '~> 2.0'
  s.add_development_dependency 'rake',      '~> 10.4'
  s.add_development_dependency 'vcr',       '~> 2.9'
end
