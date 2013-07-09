# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_broken_record/version'

Gem::Specification.new do |spec|
  spec.name          = "active_broken_record"
  spec.version       = ActiveBrokenRecord::VERSION
  spec.authors       = ["Brendon McLean"]
  spec.email         = ["brendon@intellectionsoftware.com"]
  spec.description   = %q{For finding funny usage patterns}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 3.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
