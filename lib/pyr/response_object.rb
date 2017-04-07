# frozen_string_literal: true

require 'lazy_record'

module PYR
  # The ResponseObject is the parent class of all objects instantiated
  # from the response body.
  class ResponseObject < LazyRecord::Base
    def initialize(opts = {})
      new_opts = opts.each_with_object({}) do |(key, val), memo|
        memo[key] = if PYR_RESOURCES.include?(key.to_sym)
                      objectify(key, val)
                    else
                      val
                    end
      end
      super(new_opts)
    end

    def objectify(name, array)
      array.map { |obj| "PYR::#{name.classify}".constantize.new(obj) }
    end

    def controller
      @controller ||= self.class.to_s.split('::').last.tableize
    end
  end
end
