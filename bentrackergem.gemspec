# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bentrackergem/version'

Gem::Specification.new do |spec|
  spec.name          = "bentrackergem"
  spec.version       = BenTrackerGem::VERSION
  spec.authors       = ["Ben Brostoff"]
  spec.email         = ["ben.brostoff@gmail.com"]
  spec.summary       = %q{A simple Ruby gem that serves as my virtual code, fitness and diary tracker.}
  spec.description   = %q{Leverages FitBit and GitHub to track fitness and code; messages can be input via the command line and are emailed to me via the Mandrill API.}
  spec.homepage      = "https://github.com/BenBrostoff/BenTrackerGem"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "json"
  spec.add_development_dependency "rest_client"
  spec.add_development_dependency "date"
  spec.add_development_dependency "chronic"
end
