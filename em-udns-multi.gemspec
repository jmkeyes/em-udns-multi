# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'em-udns-multi'

Gem::Specification.new do |gem|
  gem.name          = "em-udns-multi"
  gem.version       = EventMachine::Udns::Multi::VERSION

  gem.authors       = ["Joshua M. Keyes"]
  gem.email         = ["joshua.michael.keyes@gmail.com"]

  gem.description   = %q{Aggregate a large number of Udns queries together.}
  gem.summary       = %q{Aggregate DNS queries with EM::Udns.}
  gem.homepage      = "https://github.com/jmkeyes/em-udns-multi"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'em-udns'
end
