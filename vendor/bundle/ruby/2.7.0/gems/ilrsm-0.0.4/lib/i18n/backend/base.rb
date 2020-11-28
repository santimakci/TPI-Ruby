require 'yaml'
require 'i18n/core_ext/hash'
require 'i18n/core_ext/kernel/surpress_warnings'

module I18n
  module Backend
    module Base
      include I18n::Backend::Transliterator

      # Accepts a list of paths to translation files. Loads translations from
      # plain Ruby (*.rb) or YAML files (*.yml). See #load_rb and #load_yml
      # for details.
      def load_translations(*filenames)
        filenames = I18n.load_path if filenames.empty?
        filenames.flatten.each { |filename| load_file(filename) }
      end

      # This method receives a locale, a data hash and options for storing translations.
      # Should be implemented
      def store_translations(locale, data, options = {})
        raise NotImplementedError
      end

      def translate(locale, key, options = {})
        raise InvalidLocale.new(locale) unless locale
        entry = key && lookup(locale, key, options[:scope], options)

        if options.empty?
          entry = resolve(locale, key, entry, options)
        else
          count, default = options.values_at(:count, :default)
          values = options.except(*RESERVED_KEYS)
          entry = entry.nil? && default ?
            default(locale, key, default, options) : resolve(locale, key, entry, options)
        end

        throw(:exception, I18n::MissingTranslation.new(locale, key, options)) if entry.nil?
        entry = entry.dup if entry.is_a?(String)

        entry = pluralize(locale, entry, count) if count
        entry = interpolate(locale, entry, values) if values
        entry
      end

      def translated_date_and_time_object(kind, options = {})
          result = nil
          if kind.eql?(:abbr_day_names)
            result = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'].map{|x| I18n.translate(:"format.date.day.short.#{x}", :locale => options[:locale], :format => options[:format])}
          elsif kind.eql?(:day_names)
            result = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'].map{|x| I18n.translate(:"format.date.day.long.#{x}", :locale => options[:locale], :format => options[:format])}
          elsif kind.eql?(:abbr_month_names)
            result = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'].map{|x| I18n.translate(:"format.date.month.short.#{x}", :locale => options[:locale], :format => options[:format])}.unshift(nil)
          elsif kind.eql?(:month_names)
            result = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'].map{|x| I18n.translate(:"format.date.month.long.#{x}", :locale => options[:locale], :format => options[:format])}.unshift(nil)
          end
          result
        end

      # Acts the same as +strftime+, but uses a localized version of the
      # format string. Takes a key from the date/time formats translations as
      # a format argument (<em>e.g.</em>, <tt>:short</tt> in <tt>:'date.formats'</tt>).
      def localize(locale, object, format = :default, options = {})
        raise ArgumentError, "Object must be a Date, DateTime or Time object. #{object.inspect} given." unless object.respond_to?(:strftime)

        if Symbol === format
          key  = format
          type = object.respond_to?(:sec) ? 'time' : 'date'
          options = options.merge(:raise => true, :object => object, :locale => locale)
          format  = I18n.t(:"format.#{type}.display.#{key}", options)
        end

        # format = resolve(locale, object, format, options)
        format = format.to_s.gsub(/%[aAbBp]/) do |match|
          case match
          when '%a' then translated_date_and_time_object(:abbr_day_names, :locale => locale, :format => format)[object.wday]
          when '%A' then translated_date_and_time_object(:day_names, :locale => locale, :format => format)[object.wday]
          when '%b' then translated_date_and_time_object(:abbr_month_names, :locale => locale, :format => format)[object.mon]
          when '%B' then translated_date_and_time_object(:month_names, :locale => locale, :format => format)[object.mon]
          when '%p' then I18n.t(:"format.time.epoch.#{object.hour < 12 ? :am : :pm}", :locale => locale, :format => format) if object.respond_to? :hour
          end
        end

        object.strftime(format)
      end

      # Returns an array of locales for which translations are available
      # ignoring the reserved translation meta data key :i18n.
      def available_locales
        raise NotImplementedError
      end

      def reload!
        @skip_syntax_deprecation = false
      end

      protected

        # The method which actually looks up for the translation in the store.
        def lookup(locale, key, scope = [], options = {})
          raise NotImplementedError
        end

        # Evaluates defaults.
        # If given subject is an Array, it walks the array and returns the
        # first translation that can be resolved. Otherwise it tries to resolve
        # the translation directly.
        def default(locale, object, subject, options = {})
          options = options.dup.reject { |key, value| key == :default }
          case subject
          when Array
            subject.each do |item|
              result = resolve(locale, object, item, options) and return result
            end and nil
          else
            resolve(locale, object, subject, options)
          end
        end

        # Resolves a translation.
        # If the given subject is a Symbol, it will be translated with the
        # given options. If it is a Proc then it will be evaluated. All other
        # subjects will be returned directly.
        def resolve(locale, object, subject, options = {})
          return subject if options[:resolve] == false
          result = catch(:exception) do
            case subject
            when Symbol
              I18n.translate(subject, options.merge(:locale => locale, :throw => true))
            when Proc
              date_or_time = options.delete(:object) || object
              resolve(locale, object, subject.call(date_or_time, options))
            else
              subject
            end
          end
          result unless result.is_a?(MissingTranslation)
        end

        # Picks a translation from an array according to English pluralization
        # rules. It will pick the first translation if count is not equal to 1
        # and the second translation if it is equal to 1. Other backends can
        # implement more flexible or complex pluralization rules.
        def pluralize(locale, entry, count)
          return entry unless entry.is_a?(Hash) && count

          key = :zero if count == 0 && entry.has_key?(:zero)
          key ||= count == 1 ? :one : :other
          raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)
          entry[key]
        end

        # Interpolates values into a given string.
        #
        #   interpolate "file %{file} opened by %%{user}", :file => 'test.txt', :user => 'Mr. X'
        #   # => "file test.txt opened by %{user}"
        def interpolate(locale, string, values = {})
          if string.is_a?(::String) && !values.empty?
            I18n.interpolate(string, values)
          else
            string
          end
        end

        # Loads a single translations file by delegating to #load_rb or
        # #load_yml depending on the file extension and directly merges the
        # data to the existing translations. Raises I18n::UnknownFileType
        # for all other file extensions.
        def load_file(filename)
          type = File.extname(filename).tr('.', '').downcase
          raise UnknownFileType.new(type, filename) unless respond_to?(:"load_#{type}", true)
          data = send(:"load_#{type}", filename)
          raise InvalidLocaleData.new(filename) unless data.is_a?(Hash)
          data.each { |locale, d| store_translations(locale, d || {}) }
        end

        # Loads a plain Ruby translations file. eval'ing the file must yield
        # a Hash containing translation data with locales as toplevel keys.
        def load_rb(filename)
          eval(IO.read(filename), binding, filename)
        end

        # Loads a YAML translations file. The data must have locales as
        # toplevel keys.
        def load_yml(filename)
          begin
            YAML.load_file(filename)
          rescue TypeError
            nil
          rescue SyntaxError
            nil
          end
        end
    end
  end
end
