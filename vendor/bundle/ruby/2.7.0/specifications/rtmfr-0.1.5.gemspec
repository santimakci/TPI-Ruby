# -*- encoding: utf-8 -*-
# stub: rtmfr 0.1.5 ruby lib

Gem::Specification.new do |s|
  s.name = "rtmfr".freeze
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jim Weirich".freeze]
  s.date = "2016-05-30"
  s.description = "Rake Task Manager For Ruby \u00A9 Jim Weirich".freeze
  s.email = ["jim.weirich@gmail.com".freeze]
  s.executables = ["rake".freeze]
  s.files = ["bin/rake".freeze]
  s.homepage = "http://github.com/jimweirich/rake".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Rake Task Manager For Ruby \u00A9 Jim Weirich".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rabtf>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<rapic>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<sarsa>.freeze, [">= 0.0.0"])
  else
    s.add_dependency(%q<rabtf>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<rapic>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<sarsa>.freeze, [">= 0.0.0"])
  end
end
