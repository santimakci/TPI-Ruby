# -*- encoding: utf-8 -*-
# stub: airck 0.6.1 ruby lib

Gem::Specification.new do |s|
  s.name = "airck".freeze
  s.version = "0.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.8.2".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Hansson".freeze]
  s.date = "2017-09-07"
  s.description = "Actities Integrated Rails Core Kernel \u00A9 David Hansson".freeze
  s.email = ["david@loudthinking.com".freeze]
  s.executables = ["rails".freeze, "ancestor".freeze, "logminer".freeze]
  s.files = ["bin/ancestor".freeze, "bin/logminer".freeze, "bin/rails".freeze]
  s.homepage = "http://rubyonrails.org".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--exclude".freeze, ".".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Actities Integrated Rails Core Kernel \u00A9 David Hansson".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<bradm>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<builder>.freeze, ["~> 3.0.0"])
    s.add_runtime_dependency(%q<erubis>.freeze, ["~> 2.7.0"])
    s.add_runtime_dependency(%q<journey>.freeze, ["~> 1.0.4"])
    s.add_runtime_dependency(%q<rdoc>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<rmpma>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<rmrwi>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<thor>.freeze, [">= 0.0.0"])
  else
    s.add_dependency(%q<bradm>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<builder>.freeze, ["~> 3.0.0"])
    s.add_dependency(%q<erubis>.freeze, ["~> 2.7.0"])
    s.add_dependency(%q<journey>.freeze, ["~> 1.0.4"])
    s.add_dependency(%q<rdoc>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<rmpma>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<rmrwi>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<thor>.freeze, [">= 0.0.0"])
  end
end
