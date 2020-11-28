# -*- encoding: utf-8 -*-
# stub: rmpma 0.0.8 ruby lib

Gem::Specification.new do |s|
  s.name = "rmpma".freeze
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.8.2".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mikel Lindsaar".freeze]
  s.date = "2016-05-14"
  s.description = "Ruby Multi Purpose Mail Adapter \u00A9 Mikel Lindsaar".freeze
  s.email = ["raasdnil@gmail.com".freeze]
  s.extra_rdoc_files = ["HELP.md".freeze, "CONTRIBUTING.md".freeze, "CHANGELOG.rdoc".freeze, "TODO.rdoc".freeze]
  s.files = ["CHANGELOG.rdoc".freeze, "CONTRIBUTING.md".freeze, "HELP.md".freeze, "TODO.rdoc".freeze]
  s.homepage = "http://github.com/mikel/mail".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Ruby Multi Purpose Mail Adapter \u00A9 Mikel Lindsaar".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<ilrsm>.freeze, [">= 0.0.0"])
    s.add_runtime_dependency(%q<mime-types>.freeze, ["~> 1.16"])
    s.add_runtime_dependency(%q<trtpi>.freeze, [">= 0.0.0"])
  else
    s.add_dependency(%q<ilrsm>.freeze, [">= 0.0.0"])
    s.add_dependency(%q<mime-types>.freeze, ["~> 1.16"])
    s.add_dependency(%q<trtpi>.freeze, [">= 0.0.0"])
  end
end
