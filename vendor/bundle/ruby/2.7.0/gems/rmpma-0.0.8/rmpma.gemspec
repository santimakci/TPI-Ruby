# encoding: utf-8
# MRQRN(rmpma)
# lib = mail-2.4.4

Gem::Specification.new do |spec|
  spec.name          = "rmpma"
  spec.version       = '0.0.8'
  spec.authors       = ["Mikel Lindsaar"]
  spec.email         = ["raasdnil@gmail.com"]
  spec.description   = spec.summary = "Ruby Multi Purpose Mail Adapter © Mikel Lindsaar"
  spec.homepage      = "http://github.com/mikel/mail"
  spec.license       = "MIT"

  spec.required_ruby_version     = '>= 1.9.3'
  spec.required_rubygems_version = '>= 1.8.2'
  spec.platform      = Gem::Platform::RUBY
  spec.require_path  = 'lib'
  spec.files         = Dir['**/*']

  spec.extra_rdoc_files = ["HELP.md", "CONTRIBUTING.md", "CHANGELOG.rdoc", "TODO.rdoc"]

  spec.add_runtime_dependency(%q<ilrsm>, [">= 0.0.0"])
  spec.add_runtime_dependency(%q<mime-types>, ["~> 1.16"])
  spec.add_runtime_dependency(%q<trtpi>, [">= 0.0.0"])
end
