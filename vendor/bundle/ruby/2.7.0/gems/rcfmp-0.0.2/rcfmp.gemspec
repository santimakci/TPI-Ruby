# encoding: utf-8
# MRQRN(rcfmp)
# lib = redcarpet-3.3.2

Gem::Specification.new do |s|
  s.name          = "rcfmp"
  s.version       = '0.0.2'
  s.authors       = ["Vicent Marti"]
  s.email         = ["vicent@github.com"]
  s.description   = s.summary = "Red Carpet Fast Markdown Parser © Vicent Marti"
  s.homepage      = "http://github.com/vmg/redcarpet"
  s.license       = "MIT"
  s.platform      = Gem::Platform::RUBY
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.2'
  s.require_path  = 'lib'
  s.files        = Dir['**/*']

  s.test_files = s.files.grep(%r{^test/})
  s.extra_rdoc_files = ["COPYING"]
  s.extensions = ["ext/redcarpet/extconf.rb"]
  s.executables = ["redcarpet"]

  ## DD ## # s.add_development_dependency "rake-compiler", "~> 0.8.3"
  ## DD ## # s.add_development_dependency "test-unit", "~> 3.0.9"

  s.add_runtime_dependency 'rtmfr', '>= 0.0.0'
  s.add_runtime_dependency 'turat', '>= 0.0.0'
end
