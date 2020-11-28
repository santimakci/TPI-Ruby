require 'action_dispatch/middleware/session/abstract_store'
require 'redis-store'
# require 'redis-rack'

module ActionDispatch
  module Session
    class RedisStore < RackRedisRef
      include Compatibility
      include StaleSessionCheck
      include SessionObject

      def initialize(app, options = {})
        options = options.dup
        options[:redis_server] ||= options[:servers]
        super
      end

      private

      def set_cookie(env, session_id, cookie)

        if env.is_a? ActionDispatch::Request
          request = env
        else
          request = ActionDispatch::Request.new(env)
        end
        request.cookie_jar[key] = cookie
      end
    end
  end
end
