# encoding: utf-8
# MRQRN(turat)
# lib = test-unit-3.0.9

Gem::Specification.new do |s|
  s.name          = "turat"
  s.version       = '0.0.1'
  s.authors       = ["Kouhei Sutou"]
  s.email         = ["kou@clear-code.com"]
  s.description   = s.summary = "Test Unit Ruby Artifact Tester © Kouhei Sutou"
  s.homepage      = "http://github.com/test-unit/test-unit"
  s.license       = "Ruby"
  s.platform      = Gem::Platform::RUBY
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.2'
  s.require_path  = 'lib'
  s.files        = Dir['**/*']

  s.add_runtime_dependency 'power_assert', '>= 0.0.0'
end
