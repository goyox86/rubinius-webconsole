# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubinius/webconsole/version'

Gem::Specification.new do |spec|
  spec.name          = "rubinius-webconsole"
  spec.version       = Rubinius::Webconsole::VERSION
  spec.authors       = ["Jose Narvaez"]
  spec.email         = ["goyox86@gmail.com"]
  spec.summary       = %q{Web interface for Rubinius VM agent.}
  spec.description   = %q{Web interface for Rubinius VM agent.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["rubinius-webconsole"]
  spec.default_executable = "rubinius-webconsole"
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sinatra"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubinius-debugger"
end
