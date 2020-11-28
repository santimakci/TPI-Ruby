# encoding: utf-8
# MRQRN(airck)
# lib = actionmailer-3.2.8
# lib = actionpack-3.2.8
# lib = activemodel-3.2.8
# lib = activerecord-3.2.8
# lib = activeresource-3.2.8
# lib = activesupport-3.2.8
# lib = rails-3.2.8
# lib = railties-3.2.8

Gem::Specification.new do |s|
  s.name          = "airck"
  s.version       = '0.6.1'
  s.authors       = ["David Hansson"]
  s.email         = ["david@loudthinking.com"]
  s.description   = s.summary = "Actities Integrated Rails Core Kernel © David Hansson"
  s.homepage      = "http://rubyonrails.org"
  s.license       = "MIT"

  s.platform      = Gem::Platform::RUBY
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.2'
  s.require_path  = 'lib'
  s.bindir        = 'bin'
  s.executables   = ['rails', 'ancestor', 'logminer']
  s.files         = Dir['**/*']

  s.rdoc_options << '--exclude' << '.'

  # s.add_dependency 'rack-ssl', '~> 1.3.2'
  # s.add_dependency 'thor', '< 2.0', '>= 0.14.6'

  s.add_dependency 'bradm', '>= 0.0.0'
  s.add_dependency 'builder', '~> 3.0.0'
  s.add_dependency 'erubis', '~> 2.7.0'
  s.add_dependency 'journey', '~> 1.0.4'
  s.add_dependency 'rdoc', '>= 0.0.0'
  s.add_dependency 'rmpma', '>= 0.0.0'
  s.add_dependency 'rmrwi', '>= 0.0.0'
  s.add_dependency 'thor', '>= 0.0.0'
end
