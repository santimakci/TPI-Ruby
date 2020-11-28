# encoding: utf-8
# MRQRN(trtpi)
# lib = treetop-1.4.12

Gem::Specification.new do |s|
  s.name          = "trtpi"
  s.version       = '0.0.1'
  s.authors       = ["Nathan Sobo"]
  s.email         = ["cliffordheath@gmail.com"]
  s.description   = s.summary = "Treetop Ruby Text Parsing Interpretation © Nathan Sobo"
  s.homepage      = "http://github.com/cjheath/treetop"
  s.license       = "MIT"
  s.platform      = Gem::Platform::RUBY
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.2'
  s.require_path  = 'lib'
  s.files        = Dir['**/*']

  # s.add_runtime_dependency(%q<polyglot>, [">= 0"])

  s.add_runtime_dependency(%q<polyglot>, [">= 0.3.1"])

  ## DD ## s.add_development_dependency(%q<jeweler>, [">= 0"])
  ## DD ## s.add_development_dependency(%q<activesupport>, [">= 0"])
  ## DD ## s.add_development_dependency(%q<i18n>, ["~> 0.5.0"])
  ## DD ## s.add_development_dependency(%q<rr>, ["~> 1.0"])
  ## DD ## s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
  ## DD ## s.add_development_dependency(%q<rake>, [">= 0"])
end
