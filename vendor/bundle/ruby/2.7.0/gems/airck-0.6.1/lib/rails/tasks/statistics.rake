STATS_DIRECTORIES = [
  %w(Servants           app/servants),
  %w(Helpers            app/helpers),
  %w(Models             app/models),
  %w(Libraries          lib/),
  %w(Services           app/apis),
  %w(Integrations       test/integration),
  %w(Functionals        test/functional),
  %w(Units              test/unit)
].collect { |name, dir| [ name, "#{Rails.root}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }

#desc "Report code statistic from the application"
task :stats do
  require 'rails/code_statistics'
  CodeStatistics.new(*STATS_DIRECTORIES).to_s
end

desc "Report code statistic from the application"
task :statistic => "stats"
