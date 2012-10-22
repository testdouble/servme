# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'servme/version'

Gem::Specification.new do |gem|
  gem.name          = "servme"
  gem.version       = Servme::VERSION
  gem.authors       = ["Justin Searls"]
  gem.email         = ["searls@gmail.com"]
  gem.description   = "a simple test server for stubbing API responses"
  gem.summary       = "Servme lets you stub server responses by standing-in for some remote system your code under test depends on"
  gem.homepage      = "https://github.com/testdouble/servme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  ["json","sinatra","thin"].each { |d| gem.add_runtime_dependency d }

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-given", '1.4.2'
  gem.add_development_dependency "rack-test"
  # gem.add_development_dependency "debugger"
end
