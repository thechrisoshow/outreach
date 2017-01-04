# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'outreach/version'

Gem::Specification.new do |spec|
  spec.name          = "outreach"
  spec.version       = Outreach::VERSION
  spec.authors       = ["Chris O'Sullivan"]
  spec.email         = ["thechrisoshow@gmail.com"]

  spec.summary       = %q{outreach is a wrapper for the outreach.io REST API}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "webmock", "~> 1.24"
  spec.add_development_dependency "byebug"

  spec.add_dependency "httparty", "~> 0.14"
  spec.add_dependency "json", ">= 1.8", "< 3"

end
