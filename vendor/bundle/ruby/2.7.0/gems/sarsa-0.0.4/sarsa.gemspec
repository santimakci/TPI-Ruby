# encoding: utf-8
# MRQRN(sarsa)
# lib = sass-rails-3.2.6

$:.push File.expand_path("../lib", __FILE__)
require "sass/rails/version"

Gem::Specification.new do |s|
  s.name          = "sarsa"
  s.version       = '0.0.4'
  s.authors       = ["Yehuda Katz"]
  s.email         = ["wycats@gmail.com"]
  s.description   = s.summary = "Sass Advanced Rails Stylesheet Adapter © Yehuda Katz"
  s.homepage      = "http://github.com/rails/sass-rails"
  s.license       = "MIT"

  s.platform    = Gem::Platform::RUBY

  s.rubyforge_project = "sass-rails"

  s.add_runtime_dependency 'sass',       '>= 3.1.10'
  # s.add_runtime_dependency 'railties',   '~> 3.2.0'
  # s.add_runtime_dependency 'rirfe', '>= 0.0.0'
  s.add_runtime_dependency 'airck', '>= 0.0.0'
  s.add_runtime_dependency 'tilt',       '~> 1.3'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
