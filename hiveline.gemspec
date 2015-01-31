# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiveline/version'

Gem::Specification.new do |spec|
  spec.name          = "hiveline"
  spec.version       = Hiveline::VERSION
  spec.authors       = ["Chris Blanchard"]
  spec.email         = ["cablanchard@gmail.com"]
  spec.summary       = %q{A small Ruby script to change your Hive thermostat temperature through your terminal.}
  spec.description   = %q{The Hive API was reversed engineered via the Hive thermostat website (https://www.hivehome.com). This API is unsupported and undocumented. Please don't be suprised if it breaks.}
  spec.homepage      = "https://github.com/cblanc/hiveline"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.13.3"
  spec.add_dependency "json", "~> 1.8.2"
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
