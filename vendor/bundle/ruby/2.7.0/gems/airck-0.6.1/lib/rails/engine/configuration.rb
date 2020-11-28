require 'rails/railtie/configuration'

module Rails
  class Engine
    class Configuration < ::Rails::Railtie::Configuration
      attr_reader :root
      attr_writer :middleware, :eager_load_paths, :autoload_once_paths, :autoload_paths
      attr_accessor :plugins

      def initialize(root=nil)
        super()
        @root = root
        @generators = app_generators.dup
      end

      # Returns the middleware stack for the engine.
      def middleware
        @middleware ||= Rails::Configuration::MiddlewareStackProxy.new
      end

      # Holds generators configuration:
      #
      #   config.generators do |g|
      #     g.orm             :datamapper, :migration => true
      #     g.template_engine :haml
      #     g.test_framework  :rspec
      #   end
      #
      # If you want to disable color in console, do:
      #
      #   config.generators.colorize_logging = false
      #
      def generators #:nodoc:
        @generators ||= Rails::Configuration::Generators.new
        yield(@generators) if block_given?
        @generators
      end

      def paths
        @paths ||= begin
          paths = Rails::Paths::Root.new(@root)
          paths.add "app",                 :eager_load => true, :glob => "*"
          paths.add "app/assets",          :glob => "*"
          paths.add "app/servants",        :eager_load => true
          paths.add "app/helpers",         :eager_load => true
          paths.add "app/models",          :eager_load => true
          paths.add "app/mailers",         :eager_load => true
          paths.add "app/displays"
          paths.add "lib",                 :load_path => true
          paths.add "lib/assets",          :glob => "*"
          paths.add "lib/tasks",           :glob => "**/*.rake"
          paths.add "cfg" ,                :with => "cfg"
          paths.add "cfg/fragments",       :with => "cfg/fragments", :glob => "#{Rails.env}.rb"
          paths.add "cfg/injections",      :with => "cfg/injections", :glob => "**/*.rb"
          paths.add "cfg/regionals",       :with => "cfg/regionals", :glob => "*.{rb,yml}"
          paths.add "cfg/routes",          :with => "cfg/routes.rb"
          paths.add "data"
          paths.add "data/migrations"
          paths.add "data/depositors",     :with => "data/depositors.rb"
          paths.add "vendor",              :load_path => true
          paths.add "vendor/assets",       :glob => "*"
          paths.add "vendor/plugins"
          paths
        end
      end

      def root=(value)
        @root = paths.path = Pathname.new(value).expand_path
      end

      def eager_load_paths
        @eager_load_paths ||= paths.eager_load
      end

      def autoload_once_paths
        @autoload_once_paths ||= paths.autoload_once
      end

      def autoload_paths
        @autoload_paths ||= paths.autoload_paths
      end
    end
  end
end