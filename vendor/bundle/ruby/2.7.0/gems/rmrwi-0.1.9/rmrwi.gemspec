# encoding: utf-8
# MRQRN(rmrwi)
# lib = rack-1.4.1
# lib = rack-cache-1.2
# lib = rack-protection-1.3.2
# lib = rack-ssl-1.3.2
# lib = rack-test-0.6.2

Gem::Specification.new do |s|
  s.name          = "rmrwi"
  s.version       = '0.1.9'
  s.authors       = ["Christian Neukirchen"]
  s.email         = ["chneukirchen@gmail.com"]
  s.description   = s.summary = "Rack Modular Ruby Web Interface © Christian Neukirchen"
  s.homepage      = "http://rack.rubyforge.org"
  s.license       = "MIT"

  s.platform      = Gem::Platform::RUBY

  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.2'

  s.require_path  = 'lib'

  s.bindir        = 'bin'
  s.executables   << 'rackup'

  s.rdoc_options << '--exclude' << '.'

  s.files        = Dir['**/*']

  ## DD ## s.add_development_dependency 'bacon'
  ## DD ## s.add_development_dependency 'rake'
  ## DD ## s.add_development_dependency 'ruby-fcgi'
  ## DD ## s.add_development_dependency 'memcache-client'
  ## DD ## s.add_development_dependency 'mongrel' # , '>= 1.2.0.pre2'
  ## DD ## s.add_development_dependency 'thin'
  ## DD ## s.add_development_dependency "rspec" #, "~> 2.0"

  # s.extra_rdoc_files = ['HELP', 'KNOWN-ISSUES']
  # s.test_files       = Dir['test/spec_*.rb']
  # s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/}
  # s.extra_rdoc_files = %w[HELP COPYING TODO CHANGES]
  # s.has_rdoc = true
  # s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rack::Cache", "--main", "Rack::Cache"]
end
