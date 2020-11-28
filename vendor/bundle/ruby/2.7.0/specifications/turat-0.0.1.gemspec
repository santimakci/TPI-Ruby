# -*- encoding: utf-8 -*-
# stub: turat 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "turat".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.8.2".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kouhei Sutou".freeze]
  s.date = "2016-03-26"
  s.description = "Test Unit Ruby Artifact Tester \u00A9 Kouhei Sutou".freeze
  s.email = ["kou@clear-code.com".freeze]
  s.homepage = "http://github.com/test-unit/test-unit".freeze
  s.licenses = ["Ruby".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Test Unit Ruby Artifact Tester \u00A9 Kouhei Sutou".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<power_assert>.freeze, [">= 0.0.0"])
  else
    s.add_dependency(%q<power_assert>.freeze, [">= 0.0.0"])
  end
end
