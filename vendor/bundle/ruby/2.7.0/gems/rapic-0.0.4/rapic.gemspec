# encoding: utf-8
# MRQRN(rapic)
# lib = redis-3.0.2
# lib = redis-store-1.1.7

$:.unshift File.expand_path("../lib", __FILE__)

require "redis/version"

Gem::Specification.new do |s|
  s.name          = "rapic"
  s.version       = '0.0.4'
  s.authors       = ["Redis Team"]
  s.email         = ["redis-db@googlegroups.com"]
  s.description   = s.summary = "Redis Application Programming Interface Client © Redis Team"
  s.homepage      = "http://github.com/redis/redis-rb"
  s.license       = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  ## DD ## s.add_development_dependency("rake")
end
