# -*- encoding: utf-8 -*-
# stub: sarsa 0.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "sarsa".freeze
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Yehuda Katz".freeze]
  s.date = "2016-04-24"
  s.description = "Sass Advanced Rails Stylesheet Adapter \u00A9 Yehuda Katz".freeze
  s.email = ["wycats@gmail.com".freeze]
  s.homepage = "http://github.com/rails/sass-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Sass Advanced Rails Stylesheet Adapter \u00A9 Yehuda Katz".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<sass>.freeze, [">= 3.1.10"])
    s.add_runtime_dependency(%q<airck>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<tilt>.freeze, ["~> 1.3"])
  else
    s.add_dependency(%q<sass>.freeze, [">= 3.1.10"])
    s.add_dependency(%q<airck>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<tilt>.freeze, ["~> 1.3"])
  end
end
