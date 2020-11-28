# encoding: utf-8
# MRQRN(bradm)
# lib = bundler-1.5.2

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'bundler/version'

Gem::Specification.new do |spec|
  spec.name          = "bradm"
  spec.version       = '0.3.9'
  spec.authors       = ["Bundler Team"]
  spec.email         = ["andre@arko.net"]
  spec.description   = spec.summary = "Bundler Ruby Application Dependency Manager © Bundler Team"
  spec.homepage      = "http://bundler.io"
  spec.license       = "MIT"

  spec.required_ruby_version     = '>= 1.8.7'
  spec.required_rubygems_version = '>= 1.3.6'

  ## DD ## spec.add_development_dependency 'ronn', '~> 0.7.3'
  ## DD ## spec.add_development_dependency 'rspec', '~> 2.11'

  spec.files       = `git ls-files -z`.split("\x0")
  spec.files      += Dir.glob('lib/bundler/man/**/*') # man/ is ignored by git
  spec.test_files  = spec.files.grep(%r{^spec/})

  spec.executables   = %w(bundle bundler)
  spec.require_paths = ["lib"]
end
