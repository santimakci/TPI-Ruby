# encoding: utf-8
# MRQRN(rtmfr)
# lib = rake-10.0.2
# lib = rake-compiler-0.8.3

version = '3.2.8'

Gem::Specification.new do |s|
  s.name          = "rtmfr"
  s.version       = '0.1.5'
  s.authors       = ["Jim Weirich"]
  s.email         = ["jim.weirich@gmail.com"]
  s.description   = s.summary = "Rake Task Manager For Ruby © Jim Weirich"
  s.homepage      = "http://github.com/jimweirich/rake"
  s.license       = "MIT"

  s.required_ruby_version = '>= 1.9.3'
  s.platform     = Gem::Platform::RUBY

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'

  s.bindir      = 'bin'
  s.executables = ['rake']

  ## DD ## s.add_development_dependency("minitest", "~> 2.1 ")

  s.add_dependency 'rabtf', '>= 0.0.0'
  s.add_dependency 'rapic', '>= 0.0.0'
  s.add_dependency 'sarsa', '>= 0.0.0'
end
