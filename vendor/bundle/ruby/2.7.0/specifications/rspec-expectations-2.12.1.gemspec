# -*- encoding: utf-8 -*-
# stub: rspec-expectations 2.12.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-expectations".freeze
  s.version = "2.12.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Steven Baker".freeze, "David Chelimsky".freeze]
  s.date = "2012-12-16"
  s.description = "rspec expectations (should[_not] and matchers)".freeze
  s.email = "rspec-users@rubyforge.org".freeze
  s.homepage = "http://github.com/rspec/rspec-expectations".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "rspec-expectations-2.12.1".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<diff-lcs>.freeze, ["~> 1.1.3"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0.0"])
    s.add_development_dependency(%q<cucumber>.freeze, ["~> 1.1.9"])
    s.add_development_dependency(%q<aruba>.freeze, ["~> 0.4.11"])
  else
    s.add_dependency(%q<diff-lcs>.freeze, ["~> 1.1.3"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0.0"])
    s.add_dependency(%q<cucumber>.freeze, ["~> 1.1.9"])
    s.add_dependency(%q<aruba>.freeze, ["~> 0.4.11"])
  end
end
