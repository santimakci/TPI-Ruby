require 'action_dispatch/middleware/session/abstract_store'

module ActionDispatch
  module Session
    class CacheStore < AbstractStore
      def get_session(env, session_id)
        session_data = {}
        session_id ||= generate_sid
        File.open(tmp_file(session_id),'r') do |f|
          data = f.read
          session_data = ::Marshal.load(data) unless data.empty?
        end rescue nil
        [session_id, session_data]
      end

      def set_session(env, session_id, session_data, options)
        File.open(tmp_file(session_id), 'w+') do |f|
          encoded = ::Marshal.dump(session_data)
          f.write(encoded)
        end
        session_id
      end

      def destroy_session(env, session_id, options)
        File.unlink(tmp_file(session_id)) if File.exists?(tmp_file(session_id))
        generate_sid
      end

      def tmp_file(session_id)
        File.join(Rails.root, 'tmp', 'sessions', session_id)
      end
    end
  end
end
