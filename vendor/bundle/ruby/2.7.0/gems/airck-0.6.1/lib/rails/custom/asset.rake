require "fileutils"

Rake::Task.define_task('assets:publish') do
  Rake::Task["environment"].invoke
  General.writer(:instance)
end

namespace :asset do
  desc "Compile all registered application asset"
  task :compile => "assets:precompile"

  desc "Remove all compiled application asset"
  task :clean => "assets:clean"
end

namespace :assets do
  def ruby_rake_task(task, fork = true)
    env    = ENV['RAILS_ENV'] || 'production'
    groups = ENV['RAILS_GROUPS'] || 'assets'
    args   = [$0, task,"RAILS_ENV=#{env}","RAILS_GROUPS=#{groups}"]
    args << "--trace" if Rake.application.options.trace
    if $0 =~ /rake\.bat\Z/i
      Kernel.exec $0, *args
    else
      fork ? ruby(*args) : Kernel.exec(FileUtils::RUBY, *args)
    end
  end

  # We are currently running with no explicit bundler group
  # and/or no explicit environment - we have to reinvoke rake to
  # execute this task.
  def invoke_or_reboot_rake_task(task)
    if ENV['RAILS_GROUPS'].to_s.empty? || ENV['RAILS_ENV'].to_s.empty?
      ruby_rake_task task
    else
      Rake::Task[task].invoke
    end
  end

  #desc "Compile all registered application asset"
  task :precompile do
    #invoke_or_reboot_rake_task "assets:precompile:all"
    System.runtime('rake', 'assets:precompile:all RAILS_ENV=production RAILS_GROUPS=assets')
    if true # unless Rails.env.eql?('production')
      File.rename(Rails.root.to_s + '/ref/worlds/manifest.yml', Rails.root.to_s + '/ref/worlds/manifest.tmp')
      File.open(Rails.root.to_s + '/ref/worlds/manifest.yml', 'w') do |new_manifest_content|
        File.open(Rails.root.to_s + '/ref/worlds/manifest.tmp', 'r') do |old_manifest_content|
          old_manifest_content.each_line.with_index do |line, index|
            new_manifest_content.puts(line) if index > 0
          end
        end
      end
      File.delete(Rails.root.to_s + '/ref/worlds/manifest.tmp')
    end
    System.runtime('find', 'ref/assets -type d -exec chmod 777 $res_args {} \;')
    System.runtime('find', 'ref/assets -type f -exec chmod 644 $res_args {} \;')
    Rake::Task['assets:publish'].invoke
  end

  namespace :precompile do
    def internal_precompile(digest=nil)
      unless Rails.application.config.assets.enabled
        warn "Cannot precompile assets if sprockets is disabled. Please set config.assets.enabled to true"
        exit
      end

      # Ensure that action view is loaded and the appropriate
      # sprockets hooks get executed
      _ = ActionView::Base

      config = Rails.application.config
      config.assets.compile = true
      config.assets.digest  = digest unless digest.nil?
      config.assets.digests = {}

      env      = Rails.application.assets
      target   = File.join(Rails.public_path, config.assets.prefix)
      compiler = Sprockets::StaticCompiler.new(env,
                                               target,
                                               config.assets.precompile,
                                               :manifest_path => config.assets.manifest,
                                               :digest => config.assets.digest,
                                               :manifest => digest.nil?)
      compiler.compile
    end

    task :all do
      Rake::Task["assets:precompile:primary"].invoke
      # We need to reinvoke in order to run the secondary digestless
      # asset compilation run - a fresh Sprockets environment is
      # required in order to compile digestless assets as the
      # environment has already cached the assets on the primary
      # run.
      ruby_rake_task("assets:precompile:nondigest", false) if Rails.application.config.assets.digest
    end

    task :primary => ["assets:environment", "tmp:cache:clear"] do
      internal_precompile
    end

    task :nondigest => ["assets:environment", "tmp:cache:clear"] do
      internal_precompile(false)
    end
  end

  #desc "Remove all compiled application asset"
  task :clean do
    invoke_or_reboot_rake_task "assets:clean:all"
  end

  namespace :clean do
    task :all => ["assets:environment", "tmp:cache:clear"] do
      config = Rails.application.config
      public_asset_path = File.join(Rails.public_path, config.assets.prefix)
      rm_rf public_asset_path, :secure => true
    end
  end

  task :environment do
    if Rails.application.config.assets.initialize_on_precompile
      Rake::Task["environment"].invoke
    else
      require 'riana'
      Riana.resolve(:require, 'settings/alternate')
      Rails.application.initialize!(:assets)
      Sprockets::Bootstrap.new(Rails.application).run
    end
  end
end
