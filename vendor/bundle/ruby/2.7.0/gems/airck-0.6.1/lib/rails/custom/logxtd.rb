module ActiveSupport
  class Logger < ::Logger
    def self.broadcast(logger)
      Module.new do
        define_method(:add) do |*args, &block|
          logger.add(*args, &block)
          super(*args, &block)
        end

        define_method(:<<) do |x|
          logger << x
          super(x)
        end

        define_method(:close) do
          logger.close
          super()
        end

        define_method(:progname=) do |name|
          logger.progname = name
          super(name)
        end

        define_method(:formatter=) do |formatter|
          logger.formatter = formatter
          super(formatter)
        end

        define_method(:level=) do |level|
          logger.level = level
          super(level)
        end
      end
    end
  end
end

# custom_logger = Logger.new(Rails.root.join('log/alternative.log'))
# stdout_logger = Logger.new(STDOUT)

# Rails.logger.extend(ActiveSupport::Logger.broadcast(custom_logger))
# Rails.logger.extend(ActiveSupport::Logger.broadcast(stdout_logger))
