# encoding: utf-8
# MRQRN(ilrsm)
# lib = i18n-0.6.1

Gem::Specification.new do |s|
  s.name          = "ilrsm"
  s.version       = '0.0.4'
  s.authors       = ["Sven Fuchs"]
  s.email         = ["svenfuchs@artweb-design.de"]
  s.description   = s.summary = "International Local Regional Setting Manager © Sven Fuchs"
  s.homepage      = "http://github.com/svenfuchs/i18n"
  s.license       = "MIT"
  s.platform      = Gem::Platform::RUBY
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.2'
  s.require_path  = 'lib'
  s.files        = Dir['**/*']

  ## DD ## s.add_development_dependency "activesupport", "~> 3.0.0"
  ## DD ## s.add_development_dependency "mocha", ">= 0"
  ## DD ## s.add_development_dependency "sqlite3", ">= 0"
  ## DD ## s.add_development_dependency "test_declarative", ">= 0"
end
