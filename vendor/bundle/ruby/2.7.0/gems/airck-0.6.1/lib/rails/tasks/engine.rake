task "load_app" do
  namespace :app do
    load APP_RAKEFILE
  end
  task :environment => "app:environment"

  if !defined?(ENGINE_PATH) || !ENGINE_PATH
    ENGINE_PATH = find_engine_path(APP_RAKEFILE)
  end
end

def app_task(name)
  task name => [:load_app, "app:db:#{name}"]
end

namespace :db do

  #desc "Perform all pending migration \e[1mVERSION\e[0m"
  app_task "migrate"#
  #desc "Perform the latest migration up \e[1mVERSION\e[0m"
  app_task "migrate:up"#
  #desc "Perform the latest migration down \e[1mVERSION\e[0m"
  app_task "migrate:down"#
  #desc "Redo the latest migration action \e[1mVERSION\e[0m"
  app_task "migrate:redo"#
  #desc "Reset all performed migration"
  app_task "migrate:reset"#

  #desc "Display current migration status"
  app_task "migrate:status"#

  #desc 'Create database for current environment'
  app_task "create"#
  #desc 'Create database for all environment'
  app_task "create:all"#

  #desc 'Drop database for current environment'
  app_task "drop"#
  #desc 'Drop database for all environment'
  app_task "drop:all"#

  #desc 'Load fixture data into the database'
  app_task "fixtures:load"#

  #desc "Roll the schema to previous version \e[1mSTEP\e[0m"
  app_task "rollback"#

  #desc "Push the schema to next version \e[1mSTEP\e[0m"
  app_task "forward"#

  #desc "Dump schema information from the database"
  app_task "schema:dump"#

  #desc "Load schema information into the database"
  app_task "schema:load"#

  #desc "Load seed data into the database"
  app_task "seed"#

  #desc "Setup the database for initialization"
  app_task "setup"#

  #desc "Reset the database for reinitialization"
  app_task "reset"#

  #desc "Dump the database structure to an sql file"
  app_task "structure:dump"#

  #desc "Load the database structure from an sql file"
  app_task "structure:load"#

  #desc "Retrieve the current schema version number"
  app_task "version"#
end

def find_engine_path(path)
  return if path == "/"

  if Rails::Engine.find(path)
    path
  else
    find_engine_path(File.expand_path('..', path))
  end
end

Rake.application.invoke_task(:load_app) #rescue false
