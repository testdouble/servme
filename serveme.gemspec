# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'servme/version'

Gem::Specification.new do |gem|
  gem.name          = "servme"
  gem.version       = Servme::VERSION
  gem.authors       = ["Justin Searls"]
  gem.email         = ["searls@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "https://github.com/testdouble/servme"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  ["json","sinatra", "thin"].each { |d| gem.add_runtime_dependency d }
  # ["debugger"].each { |d| gem.add_development_dependency d }
end
