require 'rspec/core/rake_task'
if default = Rake.application.instance_variable_get('@tasks')['default']
  default.prerequisites.delete('test')
end

orm_setting = Rails.configuration.generators.options[:rails][:orm]
spec_prereq = if(orm_setting == :active_record)
  Rails.configuration.active_record[:schema_format] == :sql ? "db:test:clone_structure" : "db:test:prepare"
else
  :noop
end
task :noop do; end
task :default => :spec

task :stats => "spec:statsetup"

desc "Run all specification with rcov coverage"
RSpec::Core::RakeTask.new(:rcov => spec_prereq) do |t|
  t.rcov = true
  t.pattern = "./spec/**/*_spec.rb"
  t.rcov_opts = '--exclude /gems/,/Library/,/usr/,lib/tasks,.bundle,config,/lib/rspec/,/lib/rspec-,spec'
end

desc "Perform the entire test specification"
RSpec::Core::RakeTask.new(:spec => spec_prereq)

namespace :spec do
  [:requests, :models, :servants, :displays, :helpers, :mailers, :lib, :routing].each do |sub|
    desc "Perform all #{sub.eql?(:routing) ? 'route' : sub.to_s.singularize} test specification"
    RSpec::Core::RakeTask.new((sub.eql?(:routing) ? 'route' : sub.to_s.singularize) => spec_prereq) do |t|
      t.pattern = "./spec/#{sub}/**/*_spec.rb"
    end
  end

  #[:requests, :models, :servants, :displays, :helpers, :mailers, :lib, :routing].each do |sub|
  #  desc "Perform all #{sub.eql?(:routing) ? 'route' : sub.to_s.singularize} test specification"
  #  task "#{sub.eql?(:routing) ? 'route' : sub.to_s.singularize}".to_sym => "spec:#{sub}"
  #end

  #desc "Run all specification with rcov coverage"
  #RSpec::Core::RakeTask.new(:rcov => spec_prereq) do |t|
  #  t.rcov = true
  #  t.pattern = "./spec/**/*_spec.rb"
  #  t.rcov_opts = '--exclude /gems/,/Library/,/usr/,lib/tasks,.bundle,config,/lib/rspec/,/lib/rspec-,spec'
  #end

  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << %w(Model\ specs spec/models) if File.exist?('spec/models')
    ::STATS_DIRECTORIES << %w(View\ specs spec/displays) if File.exist?('spec/displays')
    ::STATS_DIRECTORIES << %w(Controller\ specs spec/servants) if File.exist?('spec/servants')
    ::STATS_DIRECTORIES << %w(Helper\ specs spec/helpers) if File.exist?('spec/helpers')
    ::STATS_DIRECTORIES << %w(Library\ specs spec/lib) if File.exist?('spec/lib')
    ::STATS_DIRECTORIES << %w(Mailer\ specs spec/mailers) if File.exist?('spec/mailers')
    ::STATS_DIRECTORIES << %w(Routing\ specs spec/routing) if File.exist?('spec/routing')
    ::STATS_DIRECTORIES << %w(Request\ specs spec/requests) if File.exist?('spec/requests')
    ::CodeStatistics::TEST_TYPES << "Model specs" if File.exist?('spec/models')
    ::CodeStatistics::TEST_TYPES << "View specs" if File.exist?('spec/displays')
    ::CodeStatistics::TEST_TYPES << "Controller specs" if File.exist?('spec/servants')
    ::CodeStatistics::TEST_TYPES << "Helper specs" if File.exist?('spec/helpers')
    ::CodeStatistics::TEST_TYPES << "Library specs" if File.exist?('spec/lib')
    ::CodeStatistics::TEST_TYPES << "Mailer specs" if File.exist?('spec/mailers')
    ::CodeStatistics::TEST_TYPES << "Routing specs" if File.exist?('spec/routing')
    ::CodeStatistics::TEST_TYPES << "Request specs" if File.exist?('spec/requests')
  end
end

