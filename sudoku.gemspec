# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sudoku/version'

Gem::Specification.new do |spec|
  spec.name          = "sudoku"
  spec.version       = Sudoku::VERSION
  spec.authors       = ["ankit"]
  spec.email         = ["aankit94k@gmail.com"]
  spec.summary       = %q{Solving Sudoku}
  spec.description   = %q{An excellent example of good Ruby code with tests}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
