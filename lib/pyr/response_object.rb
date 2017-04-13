# frozen_string_literal: true

require 'lazy_record'

module PYR
  # The ResponseObject is the parent class of all objects instantiated
  # from the response body.
  class ResponseObject < LazyRecord::Base
    def initialize(opts = {})
      new_opts = opts.each_with_object({}) do |(key, val), memo|
        memo[key] = convert_json_object_to_pyr_resource(key, val) || val
      end
      super(new_opts)
    end

    def convert_json_object_to_pyr_resource(key, val)
      if resources_include?(key)
        objectify(key, val)
      elsif resources_include_singular?(key) && val.is_a?(Hash)
        new_response_object(key, val)
      end
    end

    def resources_include_singular?(name)
      resources_include?(name.to_s.pluralize)
    end

    def resources_include?(name)
      PYR_RESOURCES.include?(name.to_sym)
    end

    def objectify(name, array)
      array.map { |obj| "PYR::#{name.to_s.classify}".constantize.new(obj) }
    end

    def new_response_object(name, opts)
      "PYR::#{name.to_s.classify}".constantize.new(opts)
    end

    def controller
      @controller ||= self.class.to_s.split('::').last.tableize
    end
  end
end
