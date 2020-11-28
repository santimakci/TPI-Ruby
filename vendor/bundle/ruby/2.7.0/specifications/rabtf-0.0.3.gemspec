# -*- encoding: utf-8 -*-
# stub: rabtf 0.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rabtf".freeze
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Chelimsky".freeze]
  s.date = "2016-03-30"
  s.description = "Rspec Automated Ruby Testing Framework \u00A9 David Chelimsky".freeze
  s.email = ["rspec-users@rubyforge.org".freeze]
  s.homepage = "http://github.com/rspec/rspec-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Rspec Automated Ruby Testing Framework \u00A9 David Chelimsky".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<airck>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<rspec-core>.freeze, ["~> 2.12.0"])
    s.add_runtime_dependency(%q<rspec-expectations>.freeze, ["~> 2.12.0"])
    s.add_runtime_dependency(%q<rspec-mocks>.freeze, ["~> 2.12.0"])
  else
    s.add_dependency(%q<airck>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<rspec-core>.freeze, ["~> 2.12.0"])
    s.add_dependency(%q<rspec-expectations>.freeze, ["~> 2.12.0"])
    s.add_dependency(%q<rspec-mocks>.freeze, ["~> 2.12.0"])
  end
end
