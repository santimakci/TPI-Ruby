require 'fileutils'
require 'optparse'
require 'action_dispatch'

module Rails
  class Server < ::Rack::Server
    class Options
      def parse!(args)
        args, options = args.dup, {}

        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: rails server [mongrel, thin, etc] [options]"
          opts.on("-p", "--port=port", Integer,
                  "Runs Rails on the specified port.", "Default: 3000") { |v| options[:Port] = v }
          opts.on("-b", "--binding=ip", String,
                  "Binds Rails to the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }
          opts.on("-c", "--config=file", String,
                  "Use custom rackup configuration file") { |v| options[:config] = v }
          opts.on("-d", "--daemon", "Make server run as a Daemon.") { options[:daemonize] = true }
          opts.on("-u", "--debugger", "Enable ruby-debugging for the server.") { options[:debugger] = true }
          opts.on("-e", "--environment=name", String,
                  "Specifies the environment to run this server under (test/development/production).",
                  "Default: development") { |v| options[:environment] = v }
          opts.on("-P","--pid=pid",String,
                  "Specifies the PID file.",
                  "Default: tmp/events/webstack.pid") { |v| options[:pid] = v }

          opts.separator ""

          opts.on("-h", "--help", "Show this help message.") { puts opts; exit }
        end

        opt_parser.parse! args

        options[:server] = args.shift
        options
      end
    end

    def initialize(*)
      super
      set_environment
    end

    def app
      @app ||= super.respond_to?(:to_app) ? super.to_app : super
    end

    def opt_parser
      Options.new
    end

    def set_environment
      ENV["RAILS_ENV"] ||= options[:environment]
    end

    def log_state(state)
      puts(Time.now.strftime('%a %d-%m-%Y %T') + ' ' + state)
    end

    def start
      # url = (options[:SSLEnable] ? 'https' : 'http') + '://' + options[:Host].to_s + ':' + options[:Port].to_s
      # log_state(('Rails ' + Rails.version.to_s).cyan + (options[:SSLEnable] ? ' Merqurion HTTPS ' : ' Merqurion HTTP ') + (Rails.env.to_s.titleize).yellow + ' ' + (options[:Port].to_s))
      # log_state('Rails ' + Rails.version.to_s + ' ' + Rails.env.to_s.titleize)
      # log_state('Rack ' + (options[:SSLEnable] ? 'Secure HTTP' : 'Basic HTTP') + ' ' + options[:Port].to_s)
      # log_state(('Rails').yellow + (' Merqurion ').white + (options[:SSLEnable] ? 'Secure HTTP ' : 'Basic HTTP ').white + (options[:Port].to_s).white + ' ' + (Rails.env.to_s.titleize).white)
      # rails_server_name = Rails.riana_value_getter('[:server][:name]').to_s
      # rails_server_instance = Rails.riana_value_getter('[:server][:instance]').to_s
      # if rails_server_name.eql?('thin')
      #   log_state(('Thin Web Server ') + (options[:SSLEnable] ? 'Secure HTTP ' : 'Plain HTTP ') + (options[:Port].to_s) + ' ' + (Rails.env.to_s.titleize))
      # elsif rails_server_name.eql?('puma')
      #   log_state(('Puma Web Server ') + rails_server_instance + (options[:SSLEnable] ? ' HTTPS ' : ' HTTP ') + (options[:Port].to_s) + ' ' + (Rails.env.to_s.titleize))
      # else
      #   log_state(('Uncommon Server ') + (options[:SSLEnable] ? 'Secure HTTP ' : 'Plain HTTP ') + (options[:Port].to_s) + ' ' + (Rails.env.to_s.titleize))
      # end
      # log_state('Starting application server action performer')
      # log_state('Starting application server service engine')
      # log_state('Starting application server interface helper')
      # log_state('Starting application server logging feature')
      Riana.abacus[:world][:running_webstack] = :ancestor
      # Riana.abacus('[:world][:running_webstack]', :ancestor, nested: true)
      trap(:INT){exit}
      %w(ref/assets ref/things ref/worlds tmp/caches tmp/events tmp/hoards tmp/linkages tmp/sessions tmp/voyages tmp/yankers uten/ancients).each do |dir_to_make|
        FileUtils.mkdir_p(Rails.root.join(dir_to_make))
      end
      super
    ensure
      unless @options and options[:daemonize]
        log_state 'Preparing for shutdown the server gracefully'
        log_state 'Terminating entire job within server instance'
      end
    end

    def middleware
      middlewares = []
      middlewares << [Rails::Rack::LogTailer, log_path] unless options[:daemonize]
      middlewares << [Rails::Rack::Debugger]  if options[:debugger]
      middlewares << [::Rack::ContentLength]
      Hash.new(middlewares)
    end

    def log_path
      "tmp/yankers/#{options[:environment]}.log"
    end

    def default_options
      super.merge({
        :Port        => 3000,
        :environment => (ENV['RAILS_ENV'] || "development").dup,
        :daemonize   => false,
        :debugger    => false,
        :pid         => File.expand_path("tmp/events/webstack.pid"),
        :config      => File.expand_path("bhvr/executors/composer.ru")
      })
    end
  end
end
