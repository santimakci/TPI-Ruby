# -*- encoding: utf-8 -*-
# stub: trtpi 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "trtpi".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.8.2".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nathan Sobo".freeze]
  s.date = "2016-03-31"
  s.description = "Treetop Ruby Text Parsing Interpretation \u00A9 Nathan Sobo".freeze
  s.email = ["cliffordheath@gmail.com".freeze]
  s.homepage = "http://github.com/cjheath/treetop".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Treetop Ruby Text Parsing Interpretation \u00A9 Nathan Sobo".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<polyglot>.freeze, [">= 0.3.1"])
  else
    s.add_dependency(%q<polyglot>.freeze, [">= 0.3.1"])
  end
end
