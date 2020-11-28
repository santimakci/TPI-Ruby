require 'riana'
require 'optparse'
require 'irb'
require 'irb/completion'

module Rails
  class Console
    def self.start(app)
      new(app).start
    end

    def initialize(app)
      @app = app
    end

    def start
      options = {}

      OptionParser.new do |opt|
        opt.banner = "Usage: console [environment] [options]"
        opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
        opt.on("--debugger", 'Enable ruby-debugging for the console.') { |v| options[:debugger] = v }
        # opt.on('--irb', "DEPRECATED: Invoke `/your/choice/of/ruby script/rails console` instead") { |v| abort '--irb option is no longer supported. Invoke `/your/choice/of/ruby script/rails console` instead' }
        # opt.on('--irb', "DEPRECATED: Invoke `/your/choice/of/ruby script/riana console` instead") { |v| abort '--irb option is no longer supported. Invoke `/your/choice/of/ruby script/riana console` instead' }
        opt.on('--irb', "DEPRECATED: Invoke `/your/choice/of/ruby bhvr/executors/governor.ru console` instead") { |v| abort '--irb option is no longer supported. Invoke `/your/choice/of/ruby bhvr/executors/governor.ru console` instead' }
        opt.parse!(ARGV)
      end

      @app.sandbox = options[:sandbox]
      @app.load_console

      if options[:debugger]
        begin
          require 'ruby-debug'
          puts "=> Debugger enabled"
        rescue Exception
          puts "You need to install ruby-debug to run the console in debugging mode. With gems, use 'gem install ruby-debug'"
          exit
        end
      end

      if options[:sandbox]
        # puts "Rails #{Rails.version} #{Rails.env.titleize} Sandbox Console"
        puts "Application #{Rails.env.titleize} Sandbox Console"
        puts ""
      else
        # puts "Rails #{Rails.version} #{Rails.env.titleize} Console"
        puts "Application #{Rails.env.titleize} Console"
        puts ""
      end

      IRB::ExtendCommandBundle.send :include, Rails::ConsoleMethods
      IRB.start
    end
  end
end

# Has to set the RAILS_ENV before config/application is required
if ARGV.first && !ARGV.first.index("-") && env = ARGV.shift # has to shift the env ARGV so IRB doesn't freak
  ENV['RAILS_ENV'] = %w(production development test).detect {|e| e =~ /^#{env}/} || env
end
