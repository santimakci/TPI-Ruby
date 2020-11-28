require 'active_support/core_ext/object/blank'

module ActiveRecord
  class Content
    def self.define(info={}, &block)
      content = new
      content.instance_eval(&block)
    end
  end
end
