require 'active_support/core_ext/string/encoding'
require 'active_support/core_ext/kernel/reporting'
require 'active_support/file_update_checker'
require 'rails/engine/configuration'

module Rails
  class Application
    class Configuration < ::Rails::Engine::Configuration
      attr_accessor :allow_concurrency, :asset_host, :asset_path, :assets,
                    :cache_classes, :cache_store, :consider_all_requests_local,
                    :dependency_loading, :exceptions_app, :file_watcher, :filter_parameters,
                    :force_ssl, :helpers_paths, :logger, :log_tags, :preload_frameworks,
                    :railties_order, :relative_url_root, :reload_plugins, :secret_token,
                    :serve_static_assets, :ssl_options, :static_cache_control, :session_options,
                    :time_zone, :reload_classes_only_on_change, :whiny_nils

      attr_writer :log_level
      attr_reader :encoding

      def initialize(*)
        super
        self.encoding = "utf-8"
        @allow_concurrency             = false
        @consider_all_requests_local   = false
        @filter_parameters             = []
        @helpers_paths                 = []
        @dependency_loading            = true
        @serve_static_assets           = true
        @static_cache_control          = nil
        @force_ssl                     = false
        @ssl_options                   = {}
        @session_store                 = :cookie_store
        @session_options               = {}
        @time_zone                     = "UTC"
        @log_level                     = nil
        @middleware                    = app_middleware
        @generators                    = app_generators
        @cache_store                   = [ :file_store, "#{root}/tmp/caches/" ]
        @railties_order                = [:all]
        @relative_url_root             = ENV["RAILS_RELATIVE_URL_ROOT"]
        @reload_classes_only_on_change = true
        @file_watcher                  = ActiveSupport::FileUpdateChecker
        @exceptions_app                = nil

        @assets = ActiveSupport::OrderedOptions.new
        @assets.enabled                  = false
        @assets.paths                    = []
        @assets.precompile               = [ Proc.new{ |path| !File.extname(path).in?(['.js', '.css']) },
                                             /(?:\/|\\|\A)application\.(css|js)$/ ]
        @assets.prefix                   = "/assets"
        @assets.version                  = ''
        @assets.debug                    = false
        @assets.compile                  = true
        @assets.digest                   = false
        @assets.manifest                 = nil
        @assets.cache_store              = [ :file_store, "#{root}/tmp/caches/raia/" ]
        @assets.js_compressor            = nil
        @assets.css_compressor           = nil
        @assets.initialize_on_precompile = true
        @assets.logger                   = nil
      end

      def compiled_asset_path
        "/"
      end

      def encoding=(value)
        @encoding = value
        if "ruby".encoding_aware?
          silence_warnings do
            Encoding.default_external = value
            Encoding.default_internal = value
          end
        else
          $KCODE = value
          if $KCODE == "NONE"
            raise "The value you specified for config.encoding is " \
                  "invalid. The possible values are UTF8, SJIS, or EUC"
          end
        end
      end

      def paths
        @paths ||= begin
          paths = super
          #paths.add "cfg/database",      :with => "cfg/database.yml"
          #paths.add "cfg/environment",   :with => "cfg/environment.rb"
          paths.add "cfg/database",       :with => ((Rails.colocation rescue (YAML.load(File.open(Rails.root.join('cfg', 'managers', 'alacrity.yml')))[Rails.env]['platform_model'])).eql?('heroku') ? "cfg/managers/database.yml" : "cfg/managers/database.yml")
          paths.add "cfg/environment",    :with => "bhvr/executors/workshop.ru"
          paths.add "lib/templates"
          paths.add "log",                :with => "tmp/yankers/#{Rails.env}.log"
          paths.add "public",             :with => "ref"
          paths.add "public/javascripts", :with => "ref/javascripts"
          paths.add "public/stylesheets", :with => "ref/stylesheets"
          paths.add "tmp"
          paths
        end
      end

      # Enable threaded mode. Allows concurrent requests to controller actions and
      # multiple database connections. Also disables automatic dependency loading
      # after boot, and disables reloading code on every request, as these are
      # fundamentally incompatible with thread safety.
      def threadsafe!
        self.preload_frameworks = true
        self.cache_classes = true
        self.dependency_loading = false
        self.allow_concurrency = true
        self
      end

      # Loads and returns the contents of the #database_configuration_file. The
      # contents of the file are processed via ERB before being sent through
      # YAML::load.
      def database_configuration
        require 'erb'
        preprocess(YAML::load(ERB.new(IO.read(paths["cfg/database"].first)).result))
      end

      def preprocess(dcf)
        dcf.each do |key, value|
          if dcf[key]['adapter'].present?
            (dcf[key]['adapter'] = 'sqlite3') if ['sqlite', 'sqlite3'].include?(dcf[key]['adapter'])
            (dcf[key]['adapter'] = 'mysql2') if ['mysql', 'mysql2'].include?(dcf[key]['adapter'])
            (dcf[key]['adapter'] = 'fb') if ['firebirdsql', 'fb'].include?(dcf[key]['adapter'])
            (dcf[key]['adapter'] = 'oracle_enhanced') if ['oracle', 'oracle_enhanced'].include?(dcf[key]['adapter'])
          end
          if dcf[key]['encoding'].present?
            (dcf[key]['encoding'] = 'UTF-8') if (['sqlite', 'sqlite3'].include?(dcf[key]['adapter']) and dcf[key]['encoding'].eql?('utf'))
            (dcf[key]['encoding'] = 'utf8') if (['mysql', 'mysql2'].include?(dcf[key]['adapter']) and dcf[key]['encoding'].eql?('utf'))
            (dcf[key]['encoding'] = 'UTF-8') if (['firebirdsql', 'fb'].include?(dcf[key]['adapter']) and dcf[key]['encoding'].eql?('utf'))
            (dcf[key]['encoding'] = 'AMERICAN_AMERICA.UTF8') if (['oracle', 'oracle_enhanced'].include?(dcf[key]['adapter']) and dcf[key]['encoding'].eql?('utf'))
          end
          if dcf[key]['variation'].present?
            if ['oracle', 'oracle_enhanced'].include?(dcf[key]['adapter'])
              dcf[key]['username'] = (dcf[key]['variation'].to_s.eql?('shared') ? dcf[key]['username'] : (dcf[key]['username'] + '_' + dcf[key]['variation']))
            else
              dcf[key]['database'] = (dcf[key]['variation'].to_s.eql?('shared') ? dcf[key]['database'] : (dcf[key]['database'] + '_' + dcf[key]['variation']))
            end
            dcf[key] = dcf[key].except('variation')
          end
          if dcf[key]['location'].present?
            (dcf[key]['database'] = (dcf[key]['location'].eql?('embed') ? 'data/treasuries' : (dcf[key]['location'].eql?('server') ? (['sqlite', 'sqlite3'].include?(dcf[key]['adapter']) ? '/cmp/sqlite/databases' : '/var/lib/firebird/2.5/data') : dcf[key]['location'])) + '/' + dcf[key]['database']) if ['sqlite', 'sqlite3', 'firebirdsql', 'fb'].include?(dcf[key]['adapter'])
            dcf[key] = dcf[key].except('location')
          end
          if dcf[key]['extension'].present?
            (dcf[key]['database'] = dcf[key]['database'] + (dcf[key]['extension'].eql?('none') ? '' : ('.' + dcf[key]['extension']))) if ['sqlite', 'sqlite3', 'firebirdsql', 'fb'].include?(dcf[key]['adapter'])
            dcf[key] = dcf[key].except('extension')
          end
          if dcf[key]['poolsize'].present?
            dcf[key]['pool'] = dcf[key]['poolsize']
            dcf[key] = dcf[key].except('poolsize')
          end
          if dcf[key]['socket'].present?
            (dcf[key]['socket'] = '/var/run/mysqld/mysqld.sock') if (['mysql', 'mysql2'].include?(dcf[key]['adapter']) and dcf[key]['socket'].eql?('default'))
          end
          if dcf[key]['timeout'].present?
            (dcf[key]['timeout'] = 5) if (['sqlite', 'sqlite3'].include?(dcf[key]['adapter']) and dcf[key]['timeout'].eql?('default'))
          end
        end
      end

      def log_level
        @log_level ||= Rails.env.production? ? :info : :debug
      end

      def colorize_logging
        @colorize_logging
      end

      def colorize_logging=(val)
        @colorize_logging = val
        ActiveSupport::LogSubscriber.colorize_logging = val
        self.generators.colorize_logging = val
      end

      def session_store(*args)
        if args.empty?
          case @session_store
          when :disabled
            nil
          when :active_record_store
            ActiveRecord::SessionStore
          when Symbol
            ActionDispatch::Session.const_get(@session_store.to_s.camelize)
          else
            @session_store
          end
        else
          @session_store = args.shift
          @session_options = args.shift || {}
        end
      end
    end
  end
end
