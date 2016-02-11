# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'beekeeper/version'

Gem::Specification.new do |spec|
  spec.name          = "beekeeper-api"
  spec.version       = Beekeeper::VERSION
  spec.authors       = ["Albin Gilles"]
  spec.email         = ["gilles.albin@gmail.com"]

  spec.summary       = %q{Little ruby api client of Beekeeper.}
  spec.description   = %q{Little ruby api client of Beekeeper.}
  spec.homepage      = "https://bitbucket.org/gopex/beekeeper-api"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "No pushing for the moment !"
  end

  spec.files         = `git ls-files`.split($\)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json"
  spec.add_dependency "rest-client"
  spec.add_dependency "api-auth"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.required_ruby_version = '>= 2.0.0'
end
