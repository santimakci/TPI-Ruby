require 'active_support/core_ext/object/inclusion'
require 'active_record'

namespace :db do
  namespace :migrate do
    desc "Display the current migration state"
    task :state => "db:migrate:status"
  end

  namespace :fixture do
    desc 'Load all fixture data into the database'
    task :load => "db:fixtures:load"
  end

  task :connection_status do
    ActiveRecord::Base.establish_connection(Rails.application.config.database_configuration[Rails.env])
    status = (ActiveRecord::Base.connection.class.name rescue 'FAIL-FAIL-FAIL'); puts status
  end
end

db_namespace = namespace :db do
  task :load_config do
    ActiveRecord::Base.configurations = Rails.application.config.database_configuration
    ActiveRecord::Migrator.migrations_paths = Rails.application.paths['data/migrations'].to_a

    if defined?(ENGINE_PATH) && engine = Rails::Engine.find(ENGINE_PATH)
      if engine.paths['data/migrations'].existent
        ActiveRecord::Migrator.migrations_paths += engine.paths['data/migrations'].to_a
      end
    end
  end

  namespace :create do
    desc 'Create database for all environment'
    task :all => :load_config do
      ActiveRecord::Base.configurations.each_value do |config|
        # Skip entries that don't have a database key, such as the first entry here:
        #
        #  defaults: &defaults
        #    adapter: mysql
        #    username: root
        #    password:
        #    host: localhost
        #
        #  development:
        #    database: blog_development
        #    *defaults
        next unless config['database']
        # Only connect to local databases
        local_database?(config) { create_database(config) }
      end
    end
  end

  desc 'Create database for current environment'
  task :create => [:load_config, :rails_env] do
    configs_for_environment.each { |config| create_database(config) }
    ActiveRecord::Base.establish_connection(configs_for_environment.first)
  end

  def mysql_creation_options(config)
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_unicode_ci'
    {:charset => (config['charset'] || @charset), :collation => (config['collation'] || @collation)}
  end

  def create_database(config)
    begin
      if config['adapter'] =~ /sqlite/
        Rowaf.support_database(:sqlite)
        if File.exist?(config['database'])
          # $stderr.puts "#{config['database']} already exists"
          dbexist = true
        else
          begin
            # Prepare the SQLite directory
            FileUtils.mkdir_p(File.dirname(config['database']))

            # Create the SQLite database
            ActiveRecord::Base.establish_connection(config)
            ActiveRecord::Base.connection

            # Prepare the SQLite database
            FileUtils.mkdir_p(File.dirname(config['database']))
            the_db_file = SQLite3::Database.new(config['database'])
            the_db_encoding = config['encoding'].eql?('utf') ? 'UTF-8' : config['encoding']
            the_db_file.execute('PRAGMA encoding = "' + the_db_encoding + '";')
            the_db_file.execute('create table blank (id int primary_key);')
            the_db_file.execute('drop table blank;')
            FileUtils.chmod('o+rw', config['database']) if Pathname.new(config['database']).dirname.to_s.eql?('/cmp/sqlite/databases')
          rescue Exception => e
            $stderr.puts e, *(e.backtrace)
            $stderr.puts "Couldn't create database for #{config.inspect}"
          end
        end
        return # Skip the else clause of begin/rescue
      else
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::Base.connection
      end
    rescue
      case config['adapter']
      when /mysql/
        if config['adapter'] =~ /jdbc/
          #FIXME After Jdbcmysql gives this class
          require 'active_record/railties/jdbcmysql_error'
          error_class = ArJdbcMySQL::Error
        else
          error_class = config['adapter'] =~ /mysql2/ ? Mysql2::Error : Mysql::Error
        end
        access_denied_error = 1045
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => nil))
          ActiveRecord::Base.connection.create_database(config['database'], mysql_creation_options(config))
          ActiveRecord::Base.establish_connection(config)
        rescue error_class => sqlerr
          if sqlerr.errno == access_denied_error
            print "#{sqlerr.error}. \nPlease provide the root password for your mysql installation\n>"
            root_password = $stdin.gets.strip
            grant_statement = "GRANT ALL PRIVILEGES ON #{config['database']}.* " \
              "TO '#{config['username']}'@'localhost' " \
              "IDENTIFIED BY '#{config['password']}' WITH GRANT OPTION;"
            ActiveRecord::Base.establish_connection(config.merge(
                'database' => nil, 'username' => 'root', 'password' => root_password))
            ActiveRecord::Base.connection.create_database(config['database'], mysql_creation_options(config))
            ActiveRecord::Base.connection.execute grant_statement
            ActiveRecord::Base.establish_connection(config)
          else
            $stderr.puts sqlerr.error
            $stderr.puts "Couldn't create database for #{config.inspect}, charset: #{config['charset'] || @charset}, collation: #{config['collation'] || @collation}"
            $stderr.puts "(if you set the charset manually, make sure you have a matching collation)" if config['charset']
          end
        end
      when /postgresql/
        @encoding = config['encoding'] || ENV['CHARSET'] || 'utf8'
        begin
          ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
          ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => @encoding))
          ActiveRecord::Base.establish_connection(config)
        rescue Exception => e
          $stderr.puts e, *(e.backtrace)
          $stderr.puts "Couldn't create database for #{config.inspect}"
        end
      when /oracle/
        Rowaf.support_database(:oracle)
        if (config['admin'].present? and config['superkey'].present?)
          database_live_connecion = OCI8.new(config['admin'], config['superkey'])
          database_live_connecion.exec('CREATE USER ' + config['username'] + ' IDENTIFIED BY ' + config['password'] + ' ACCOUNT UNLOCK')
          database_live_connecion.exec('GRANT CONNECT TO ' + config['username'])
          database_live_connecion.exec('GRANT RESOURCE TO ' + config['username'])
          if config['fullgrant'].eql?(true) or config['fullgrant'].eql?('true')
            database_live_connecion.exec('GRANT DBA TO ' + config['username'])
            database_live_connecion.exec('GRANT ALL PRIVILEGES TO ' + config['username'])
          end
        end
      when 'microsoftsql', 'mssql', 'mssqlserver', 'sqlserver'
        # '=== MRQRN ==='
        Rowaf.support_database(:sqlserver)
        database_name = config['database']
        database_path = config['path']
        if (database_path.eql?('default'))
          if (config['version'].eql?('classic'))
            database_path = "C:\\MSSQL\\Data\\"
          else
            database_path = "C:\\MSSQL\\Data\\"
          end
        end
        database_coll = config['encoding'].eql?('default') ? "" : " COLLATE #{config['encoding']}"
        if (true)
          database_coll = ""
        end
        query_create = ""
        if (config['version'].eql?('classic'))
          query_create = "
            CREATE DATABASE #{database_name}
            ON  PRIMARY (
              NAME = N'#{database_name}_D',
              FILENAME = N'#{database_path}#{database_name}_D.mdf',
              SIZE = 32MB,
              FILEGROWTH = 8MB
            )
            LOG ON (
              NAME = N'#{database_name}_L',
              FILENAME = N'#{database_path}#{database_name}_L.ldf',
              SIZE = 32MB,
              FILEGROWTH = 8MB
            )
            #{database_coll}
          "
        else
          query_create = "
            CREATE DATABASE #{database_name}
            ON  PRIMARY (
              NAME = N'#{database_name}_D',
              FILENAME = N'#{database_path}#{database_name}_D.mdf',
              SIZE = 256MB,
              FILEGROWTH = 64MB
            )
            LOG ON (
              NAME = N'#{database_name}_L',
              FILENAME = N'#{database_path}#{database_name}_L.ldf',
              SIZE = 256MB,
              FILEGROWTH = 64MB
            )
            #{database_coll}
          "
        end
        query_check = "
          SELECT name
          FROM master.dbo.sysdatabases
          WHERE ('[' + name + ']' = '#{database_name}' OR name = '#{database_name}')
        "
        status_done = false
        status_next = 0
        begin
          database_live_connecion = TinyTds::Client.new(username: config['username'], password: config['password'], host: config['host'], port: config['port'])
          while (status_done.eql?(false) and database_live_connecion.active? and (status_next < 10))
            begin
              dbres = database_live_connecion.execute(query_create)
              sleep(10)
              dbres = database_live_connecion.execute(query_check)
              if (dbres.each(:symbolize_keys => true).to_a.count > 0)
                status_done = true
              end
            rescue Exception => exception
              status_next = status_next + 1
              next
            end
          end
          database_live_connecion.close()
        rescue Exception => exception
          status_next = status_next + 1
          p "RESCUE: #{exception}"
        end
      end
    else
      # Bug with 1.9.2 Calling return within begin still executes else
      # $stderr.puts "#{config['database']} already exists" unless config['adapter'] =~ /sqlite/
      dbexist = true
    end
  end

  namespace :drop do
    desc 'Drop database for all environment'
    task :all => :load_config do
      ActiveRecord::Base.configurations.each_value do |config|
        # Skip entries that don't have a database key
        next unless config['database']
        begin
          # Only connect to local databases
          local_database?(config) { drop_database(config) }
        rescue Exception => e
          $stderr.puts "Couldn't drop #{config['database']} : #{e.inspect}"
        end
      end
    end
  end

  desc 'Drop database for current environment'
  task :drop => [:load_config, :rails_env] do
    configs_for_environment.each { |config| drop_database_and_rescue(config) }
  end

  def local_database?(config, &block)
    if config['host'].in?(['127.0.0.1', 'localhost']) || config['host'].blank?
      yield
    else
      $stderr.puts "This task only modifies local databases. #{config['database']} is on a remote host."
    end
  end

  ###desc "Perform all pending migration \e[1mVERSION VERBOSE\e[0m"
  desc "Perform all pending migration \e[1mVERSION\e[0m"
  task :migrate => [:environment, :load_config] do
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
      ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
    end
    db_namespace['_dump'].invoke
  end

  task :_dump do
    case ActiveRecord::Base.schema_format
    when :ruby then db_namespace["schema:dump"].invoke
    when :sql  then db_namespace["structure:dump"].invoke
    else
      raise "unknown schema format #{ActiveRecord::Base.schema_format}"
    end
    # Allow this task to be called as many times as required. An example is the
    # migrate:redo task, which calls other two internally that depend on this one.
    db_namespace['_dump'].reenable
  end

  namespace :migrate do
    ###desc  "Redo the latest migration action \e[1mVERSION STEP\e[0m"
    desc  "Redo the latest migration action \e[1mVERSION\e[0m"
    task :redo => [:environment, :load_config] do
      if ENV['VERSION']
        db_namespace['migrate:down'].invoke
        db_namespace['migrate:up'].invoke
      else
        db_namespace['rollback'].invoke
        db_namespace['migrate'].invoke
      end
    end

    desc "Reset all migration to be performed again"
    task :reset => ['db:drop', 'db:create', 'db:migrate']

    desc "Perform the latest migration up \e[1mVERSION\e[0m"
    task :up => [:environment, :load_config] do
      version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
      raise 'VERSION is required' unless version
      ActiveRecord::Migrator.run(:up, ActiveRecord::Migrator.migrations_paths, version)
      db_namespace['_dump'].invoke
    end

    desc "Perform the latest migration down \e[1mVERSION\e[0m"
    task :down => [:environment, :load_config] do
      version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
      raise 'VERSION is required' unless version
      ActiveRecord::Migrator.run(:down, ActiveRecord::Migrator.migrations_paths, version)
      db_namespace['_dump'].invoke
    end

    #desc "Display the current migration status"
    task :status => [:environment, :load_config] do
      config = ActiveRecord::Base.configurations[Rails.env]
      ActiveRecord::Base.establish_connection(config)
      unless ActiveRecord::Base.connection.table_exists?(ActiveRecord::Migrator.schema_migrations_table_name)
        puts 'Schema migrations table does not exist yet.'
        next  # means "return" for rake task
      end
      db_list = ActiveRecord::Base.connection.select_values("SELECT version FROM #{ActiveRecord::Migrator.schema_migrations_table_name}")
      file_list = []
      ActiveRecord::Migrator.migrations_paths.each do |path|
        Dir.foreach(path) do |file|
          # only files matching "20091231235959_some_name.rb" pattern
          if match_data = /^(\d{14})_(.+)\.rb$/.match(file)
            status = db_list.delete(match_data[1]) ? 'up' : 'down'
            file_list << [status, match_data[1], match_data[2].humanize]
          end
        end
      end
      db_list.map! do |version|
        ['up', version, '********** NO FILE **********']
      end
      # output
      puts "\ndatabase: #{config['database']}\n\n"
      puts "#{'State'.center(8)}  #{'Migration ID'.center(14)}  Migration Name"
      puts "-" * 50
      (db_list + file_list).sort_by {|migration| migration[1]}.each do |migration|
        puts "#{migration[0].center(8)}  #{migration[1].ljust(14)}  #{migration[2]}"
      end
      puts
    end
  end

  desc "Roll the schema to previous version \e[1mSTEP\e[0m"
  task :rollback => [:environment, :load_config] do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
    db_namespace['_dump'].invoke
  end

  desc "Push the schema to next version \e[1mSTEP\e[0m"
  task :forward => [:environment, :load_config] do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.forward(ActiveRecord::Migrator.migrations_paths, step)
    db_namespace['_dump'].invoke
  end

  desc "Reset the database for reinitialization"
  task :reset => [:environment, :load_config] do
    db_namespace["drop"].invoke
    db_namespace["setup"].invoke
  end

  # desc "Retrieves the charset for the current environment's database"
  task :charset => [:environment, :load_config] do
    config = ActiveRecord::Base.configurations[Rails.env]
    case config['adapter']
    when /mysql/
      ActiveRecord::Base.establish_connection(config)
      puts ActiveRecord::Base.connection.charset
    when /postgresql/
      ActiveRecord::Base.establish_connection(config)
      puts ActiveRecord::Base.connection.encoding
    when /sqlite/
      ActiveRecord::Base.establish_connection(config)
      puts ActiveRecord::Base.connection.encoding
    else
      $stderr.puts 'sorry, your database adapter is not supported yet, feel free to submit a patch'
    end
  end

  # desc "Retrieves the collation for the current environment's database"
  task :collation => [:environment, :load_config] do
    config = ActiveRecord::Base.configurations[Rails.env]
    case config['adapter']
    when /mysql/
      ActiveRecord::Base.establish_connection(config)
      puts ActiveRecord::Base.connection.collation
    else
      $stderr.puts 'sorry, your database adapter is not supported yet, feel free to submit a patch'
    end
  end

  desc "Retrieve the current schema version number"
  task :version => [:environment, :load_config] do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end

  # desc "Raises an error if there are pending migrations"
  task :abort_if_pending_migrations => [:environment, :load_config] do
    pending_migrations = ActiveRecord::Migrator.new(:up, ActiveRecord::Migrator.migrations_paths).pending_migrations

    if pending_migrations.any?
      puts "You have #{pending_migrations.size} pending migrations:"
      pending_migrations.each do |pending_migration|
        puts '  %4d %s' % [pending_migration.version, pending_migration.name]
      end
      abort %{Run `rake db:migrate` to update your database then try again.}
    end
  end

  desc "Setup the database for initialization"
  task :setup => ['db:schema:load_if_ruby', 'db:structure:load_if_sql', :seed]

  desc "Load all seed data into the database"
  task :seed do
    #db_namespace['abort_if_pending_migrations'].invoke
    #Rails.application.load_seed
    content_file_path = Rails.root.to_s + '/data/structures/content.rb'
    load(content_file_path) if File.exist?(content_file_path)
  end

  namespace :fixtures do
    ###desc "Load fixtures into the current environment's database. Load specific fixtures using FIXTURES=x,y. Load from subdirectory in test/fixtures using FIXTURES_DIR=z. Specify an alternative path (eg. spec/fixtures) using FIXTURES_PATH=spec/fixtures."
    #desc 'Load fixture data into the database'
    task :load => [:environment, :load_config] do
      require 'active_record/fixtures'

      ActiveRecord::Base.establish_connection(Rails.env)
      base_dir     = File.join [Rails.root, ENV['FIXTURES_PATH'] || %w{test fixtures}].flatten
      fixtures_dir = File.join [base_dir, ENV['FIXTURES_DIR']].compact

      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir["#{fixtures_dir}/**/*.{yml,csv}"].map {|f| f[(fixtures_dir.size + 1)..-5] }).each do |fixture_file|
        ActiveRecord::Fixtures.create_fixtures(fixtures_dir, fixture_file)
      end
    end

    # desc "Search for a fixture given a LABEL or ID. Specify an alternative path (eg. spec/fixtures) using FIXTURES_PATH=spec/fixtures."
    task :identify => [:environment, :load_config] do
      require 'active_record/fixtures'

      label, id = ENV['LABEL'], ENV['ID']
      raise 'LABEL or ID required' if label.blank? && id.blank?

      puts %Q(The fixture ID for "#{label}" is #{ActiveRecord::Fixtures.identify(label)}.) if label

      base_dir = ENV['FIXTURES_PATH'] ? File.join(Rails.root, ENV['FIXTURES_PATH']) : File.join(Rails.root, 'test', 'fixtures')
      Dir["#{base_dir}/**/*.yml"].each do |file|
        if data = YAML::load(ERB.new(IO.read(file)).result)
          data.keys.each do |key|
            key_id = ActiveRecord::Fixtures.identify(key)

            if key == label || key_id == id.to_i
              puts "#{file}: #{key} (#{key_id})"
            end
          end
        end
      end
    end
  end

  namespace :schema do
    desc "Dump the database to schema information file"
    task :dump => [:environment, :load_config] do
      require 'active_record/schema_dumper'
      filename = ENV['SCHEMA'] || "#{Rails.root}/data/structures/schema.rb"
      File.open(filename, "w:utf-8") do |file|
        ActiveRecord::Base.establish_connection(Rails.env)
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
      db_namespace['schema:dump'].reenable
      # Additional Action
      File.open(Rails.root.to_s + '/data/structures/schema.tmp', 'w') do |new_schema_content|
        if false
          new_schema_content.puts('## This schema file is automatically generated from the current state of the database')
          new_schema_content.puts('## Instead of editing this file, please use the migrations feature of active record')
          new_schema_content.puts('## Note that this schema definition is the authoritative source for the database schema')
          new_schema_content.puts('## Please use db:schema:load task to create the application database on another system')
          new_schema_content.puts('## The more migrations provided, the slower for runtime and the greater for issues')
          new_schema_content.puts('## This file is strongly recommended to be included into the version control system')
        end
        line_length = File.open(Rails.root.to_s + '/data/structures/schema.rb', 'r').readlines.size
        File.open(Rails.root.to_s + '/data/structures/schema.rb', 'r') do |old_schema_content|
          replacements = [['ActiveRecord::Schema', 'RianaSchema'], [/(,)\s+/, ', '], ['"', '\''], [':version =>', 'version:'], [':force =>', 'force:'], [':null =>', 'null:'], [':name =>', 'name:'], [' \'', ' :'], ['\' ', ' '], ['[\'', '[:'], ['\']', ']'], ['\',', ','], ['\'', ''], [':limit =>', 'limit:'], [':precision =>', 'precision:'], [':scale =>', 'scale:'], [', limit: 4000', ''], [', precision: 38, scale: 0', ''], [', precision: 30, scale: 5', '']]
          old_schema_content.each_line.with_index do |line, index|
            new_schema_content.puts((replacements.each{|replacement| line = line.gsub(replacement.first, replacement.last)}; line)) if ((index>12) and (index!=14) and (index!=line_length-2))
          end
        end
      end
      File.delete(Rails.root.to_s + '/data/structures/schema.rb')
      File.rename(Rails.root.to_s + '/data/structures/schema.tmp', Rails.root.to_s + '/data/structures/schema.rb')
    end

    desc "Load the database from schema information file"
    task :load => [:environment, :load_config] do
      schema_file_path = Rails.root.to_s + '/data/structures/schema.rb'
      load(schema_file_path) if File.exist?(schema_file_path)
      #file = ENV['SCHEMA'] || "#{Rails.root}/data/structures/schema.rb"
      #if File.exists?(file)
      #  load(file)
      #else
      #  abort %{#{file} doesn't exist yet. Run `rake db:migrate` to create it then try again. If you do not intend to use a database, you should instead alter #{Rails.root}/config/application.rb to limit the frameworks that will be loaded}
      #end
    end

    task :load_if_ruby => 'db:create' do
      db_namespace["schema:load"].invoke if ActiveRecord::Base.schema_format == :ruby
    end
  end

  namespace :structure do
    ###desc 'Dump the database structure to data/structures.sql. Specify another file with DB_STRUCTURE=data/my_structures.sql'
    desc "Dump the database structure to sql file"
    task :dump => [:environment, :load_config] do
      abcs = ActiveRecord::Base.configurations
      filename = ENV['DB_STRUCTURE'] || File.join(Rails.root, "data", "structure.sql")
      case abcs[Rails.env]['adapter']
      when /mysql/, 'oci', 'oracle'
        ActiveRecord::Base.establish_connection(abcs[Rails.env])
        File.open(filename, "w:utf-8") { |f| f << ActiveRecord::Base.connection.structure_dump }
      when /postgresql/
        set_psql_env(abcs[Rails.env])
        search_path = abcs[Rails.env]['schema_search_path']
        unless search_path.blank?
          search_path = search_path.split(",").map{|search_path_part| "--schema=#{Shellwords.escape(search_path_part.strip)}" }.join(" ")
        end
        `pg_dump -i -s -x -O -f #{Shellwords.escape(filename)} #{search_path} #{Shellwords.escape(abcs[Rails.env]['database'])}`
        raise 'Error dumping database' if $?.exitstatus == 1
      when /sqlite/
        dbfile = abcs[Rails.env]['database']
        `sqlite3 #{dbfile} .schema > #{filename}`
      when 'microsoftsql', 'mssql', 'mssqlserver', 'sqlserver'
        `smoscript -s #{abcs[Rails.env]['host']} -d #{abcs[Rails.env]['database']} -u #{abcs[Rails.env]['username']} -p #{abcs[Rails.env]['password']} -f #{filename} -A -U`
      when "firebird"
        set_firebird_env(abcs[Rails.env])
        db_string = firebird_db_string(abcs[Rails.env])
        sh "isql -a #{db_string} > #{filename}"
      else
        raise "Task not supported by '#{abcs[Rails.env]["adapter"]}'"
      end

      if ActiveRecord::Base.connection.supports_migrations?
        File.open(filename, "a") { |f| f << ActiveRecord::Base.connection.dump_schema_information }
      end
      db_namespace['structure:dump'].reenable
    end

    desc "Load the database structure from sql file"
    task :load => [:environment, :load_config] do
      env = ENV['RAILS_ENV'] || 'test'

      abcs = ActiveRecord::Base.configurations
      filename = ENV['DB_STRUCTURE'] || File.join(Rails.root, "data", "structure.sql")
      case abcs[env]['adapter']
      when /mysql/
        ActiveRecord::Base.establish_connection(abcs[env])
        ActiveRecord::Base.connection.execute('SET foreign_key_checks = 0')
        IO.read(filename).split("\n\n").each do |table|
          ActiveRecord::Base.connection.execute(table)
        end
      when /postgresql/
        set_psql_env(abcs[env])
        `psql -f "#{filename}" #{abcs[env]['database']}`
      when /sqlite/
        dbfile = abcs[env]['database']
        `sqlite3 #{dbfile} < "#{filename}"`
      when 'microsoftsql', 'mssql', 'mssqlserver', 'sqlserver'
        `sqlcmd -S #{abcs[env]['host']} -d #{abcs[env]['database']} -U #{abcs[env]['username']} -P #{abcs[env]['password']} -i #{filename}`
      when 'oci', 'oracle'
        ActiveRecord::Base.establish_connection(abcs[env])
        IO.read(filename).split(";\n\n").each do |ddl|
          ActiveRecord::Base.connection.execute(ddl)
        end
      when 'firebird'
        set_firebird_env(abcs[env])
        db_string = firebird_db_string(abcs[env])
        sh "isql -i #{filename} #{db_string}"
      else
        raise "Task not supported by '#{abcs[env]['adapter']}'"
      end
    end

    task :load_if_sql => 'db:create' do
      db_namespace["structure:load"].invoke if ActiveRecord::Base.schema_format == :sql
    end
  end

  namespace :test do

    # desc "Recreate the test database from the current schema"
    task :load => 'db:test:purge' do
      case ActiveRecord::Base.schema_format
        when :ruby
          db_namespace["test:load_schema"].invoke
        when :sql
          db_namespace["test:load_structure"].invoke
      end
    end

    # desc "Recreate the test database from an existent structure.sql file"
    task :load_structure => 'db:test:purge' do
      begin
        old_env, ENV['RAILS_ENV'] = ENV['RAILS_ENV'], 'test'
        db_namespace["structure:load"].invoke
      ensure
        ENV['RAILS_ENV'] = old_env
      end
    end

    # desc "Recreate the test database from an existent schema.rb file"
    task :load_schema => 'db:test:purge' do
      ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
      ActiveRecord::Schema.verbose = false
      db_namespace["schema:load"].invoke
    end

    # desc "Recreate the test database from a fresh schema.rb file"
    task :clone => %w(db:schema:dump db:test:load_schema)

    # desc "Recreate the test database from a fresh structure.sql file"
    task :clone_structure => [ "db:structure:dump", "db:test:load_structure" ]

    # desc "Empty the test database"
    task :purge => [:environment, :load_config] do
      abcs = ActiveRecord::Base.configurations
      case abcs['test']['adapter']
      when /mysql/
        ActiveRecord::Base.establish_connection(:test)
        ActiveRecord::Base.connection.recreate_database(abcs['test']['database'], mysql_creation_options(abcs['test']))
      when /postgresql/
        ActiveRecord::Base.clear_active_connections!
        drop_database(abcs['test'])
        create_database(abcs['test'])
      when /sqlite/
        dbfile = abcs['test']['database']
        File.delete(dbfile) if File.exist?(dbfile)
      when 'microsoftsql', 'mssql', 'mssqlserver', 'sqlserver'
        test = abcs.deep_dup['test']
        test_database = test['database']
        test['database'] = 'master'
        ActiveRecord::Base.establish_connection(test)
        ActiveRecord::Base.connection.recreate_database!(test_database)
      when "oci", "oracle"
        ActiveRecord::Base.establish_connection(:test)
        ActiveRecord::Base.connection.structure_drop.split(";\n\n").each do |ddl|
          ActiveRecord::Base.connection.execute(ddl)
        end
      when 'firebird'
        ActiveRecord::Base.establish_connection(:test)
        ActiveRecord::Base.connection.recreate_database!
      else
        raise "Task not supported by '#{abcs['test']['adapter']}'"
      end
    end

    # desc 'Check for pending migrations and load the test schema'
    task :prepare => 'db:abort_if_pending_migrations' do
      unless ActiveRecord::Base.configurations.blank?
        db_namespace[{ :sql  => 'test:clone_structure', :ruby => 'test:load' }[ActiveRecord::Base.schema_format]].invoke
      end
    end
  end

  namespace :sessions do
    # desc "Creates a sessions migration for use with ActiveRecord::SessionStore"
    task :create => [:environment, :load_config] do
      raise 'Task unavailable to this database (no migration support)' unless ActiveRecord::Base.connection.supports_migrations?
      Rails.application.load_generators
      require 'rails/generators/rails/session_migration/session_migration_generator'
      Rails::Generators::SessionMigrationGenerator.start [ ENV['MIGRATION'] || 'add_sessions_table' ]
    end

    # desc "Clear the sessions table"
    task :clear => [:environment, :load_config] do
      ActiveRecord::Base.connection.execute "DELETE FROM #{session_table_name}"
    end
  end
end

namespace :railties do
  namespace :install do
    # desc "Copies missing migrations from Railties (e.g. plugins, engines). You can specify Railties to use with FROM=railtie1,railtie2"
    task :migrations => :'db:load_config' do
      to_load = ENV['FROM'].blank? ? :all : ENV['FROM'].split(",").map {|n| n.strip }
      railties = ActiveSupport::OrderedHash.new
      Rails.application.railties.all do |railtie|
        next unless to_load == :all || to_load.include?(railtie.railtie_name)

        if railtie.respond_to?(:paths) && (path = railtie.paths['data/migrations'].first)
          railties[railtie.railtie_name] = path
        end
      end

      on_skip = Proc.new do |name, migration|
        puts "NOTE: Migration #{migration.basename} from #{name} has been skipped. Migration with the same name already exists."
      end

      on_copy = Proc.new do |name, migration, old_path|
        puts "Copied migration #{migration.basename} from #{name}"
      end

      ActiveRecord::Migration.copy(ActiveRecord::Migrator.migrations_paths.first, railties,
                                    :on_skip => on_skip, :on_copy => on_copy)
    end
  end
end

task 'test:prepare' => 'db:test:prepare'

def drop_database(config)
  case config['adapter']
  when /mysql/
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Base.connection.drop_database config['database']
  when /sqlite/
    require 'pathname'
    path = Pathname.new(config['database'])
    file = path.absolute? ? path.to_s : File.join(Rails.root, path)

    FileUtils.rm(file)
  when /postgresql/
    ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
    ActiveRecord::Base.connection.drop_database config['database']
  when /oracle/
    Rowaf.support_database(:oracle)
    if (config['admin'].present? and config['superkey'].present?)
      database_live_connecion = OCI8.new(config['admin'], config['superkey'])
      database_live_connecion.exec('alter user ' + config['username'] + ' account lock') rescue false
      database_live_connecion.exec('revoke connect from ' + config['username']) rescue false
      database_live_connecion.exec('revoke create session from ' + config['username']) rescue false
      present_conn_session = true
      kill_session = true
      max_retry = 10
      ttl_retry = 0
      while kill_session and present_conn_session and (ttl_retry < max_retry)
        sleep(10)
        total_session = 0
        search_query = ("select sid, serial# from v$session where username = '" + config['username'].upcase + "' or username = '" + config['username'].downcase + "'")
        # p search_query
        database_live_connecion.exec(search_query) do |search_result|
          total_session = total_session + 1
          kill_query = ("alter system kill session '" + search_result[0].to_i.to_s + "," + search_result[1].to_i.to_s + "' immediate")
          # p kill_query
          database_live_connecion.exec(kill_query)
          stop_query = ("alter system disconnect session '" + search_result[0].to_i.to_s + "," + search_result[1].to_i.to_s + "' immediate")
          # p stop_query
          database_live_connecion.exec(stop_query)
        end
        # p total_session
        if (total_session == 0)
          present_conn_session = false
        end
        ttl_retry = ttl_retry + 1
      end
      sleep(10)
      database_live_connecion.exec('DROP USER ' + config['username'] + ' CASCADE')
    end
  when 'microsoftsql', 'mssql', 'mssqlserver', 'sqlserver'
    # '=== MRQRN ==='
    Rowaf.support_database(:sqlserver)
    database_name = config['database']
    query_drop = ""
    if (config['version'].eql?('classic'))
      query_drop = "
        DROP DATABASE #{database_name}
      "
    else
      query_drop = "
        DROP DATABASE IF EXISTS #{database_name}
      "
    end
    query_check = "
      SELECT name
      FROM master.dbo.sysdatabases
      WHERE ('[' + name + ']' = '#{database_name}' OR name = '#{database_name}')
    "
    status_done = false
    status_next = 0
    begin
      database_live_connecion = TinyTds::Client.new(username: config['username'], password: config['password'], host: config['host'], port: config['port'])
      while (status_done.eql?(false) and database_live_connecion.active? and (status_next < 10))
        begin
          dbres = database_live_connecion.execute(query_drop)
          sleep(10)
          dbres = database_live_connecion.execute(query_check)
          if (dbres.each(:symbolize_keys => true).to_a.count.eql?(0))
            status_done = true
          end
        rescue Exception => exception
          status_next = status_next + 1
          next
        end
      end
      database_live_connecion.close()
    rescue Exception => exception
      status_next = status_next + 1
      p "RESCUE: #{exception}"
    end
  end
end

def drop_database_and_rescue(config)
  begin
    drop_database(config)
  rescue Exception => e
    $stderr.puts "Couldn't drop #{config['database']} : #{e.inspect}"
  end
end

def configs_for_environment
  environments = [Rails.env]
  environments << 'test' if Rails.env.development?
  ActiveRecord::Base.configurations.values_at(*environments).compact.reject { |config| config['database'].blank? }
end

def session_table_name
  ActiveRecord::SessionStore::Session.table_name
end

def set_firebird_env(config)
  ENV['ISC_USER']     = config['username'].to_s if config['username']
  ENV['ISC_PASSWORD'] = config['password'].to_s if config['password']
end

def firebird_db_string(config)
  FireRuby::Database.db_string_for(config.symbolize_keys)
end

def set_psql_env(config)
  ENV['PGHOST']     = config['host']          if config['host']
  ENV['PGPORT']     = config['port'].to_s     if config['port']
  ENV['PGPASSWORD'] = config['password'].to_s if config['password']
  ENV['PGUSER']     = config['username'].to_s if config['username']
end

#Rails.riana_patch(:rake)
