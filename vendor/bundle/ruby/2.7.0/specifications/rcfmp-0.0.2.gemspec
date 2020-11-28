# -*- encoding: utf-8 -*-
# stub: rcfmp 0.0.2 ruby lib
# stub: ext/redcarpet/extconf.rb

Gem::Specification.new do |s|
  s.name = "rcfmp".freeze
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.8.2".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Vicent Marti".freeze]
  s.date = "2016-03-30"
  s.description = "Red Carpet Fast Markdown Parser \u00A9 Vicent Marti".freeze
  s.email = ["vicent@github.com".freeze]
  s.executables = ["redcarpet".freeze]
  s.extensions = ["ext/redcarpet/extconf.rb".freeze]
  s.extra_rdoc_files = ["COPYING".freeze]
  s.files = ["COPYING".freeze, "bin/redcarpet".freeze, "ext/redcarpet/extconf.rb".freeze]
  s.homepage = "http://github.com/vmg/redcarpet".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Red Carpet Fast Markdown Parser \u00A9 Vicent Marti".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rtmfr>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<turat>.freeze, [">= 0.0.0"])
  else
    s.add_dependency(%q<rtmfr>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<turat>.freeze, [">= 0.0.0"])
  end
end
