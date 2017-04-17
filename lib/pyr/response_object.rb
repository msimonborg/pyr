# frozen_string_literal: true

# The LazyRecord gem provides hash and block constructor syntax,
# attribute, association, and scope definition macros, and object
# collections. It gives objects an API similar to ActiveRecord,
# turning the raw JSON response into a collection of associated
# Ruby objects.
require 'lazy_record'

module PYR
  # The ResponseObject is the parent class of all objects instantiated
  # from the response body.
  class ResponseObject < LazyRecord::Base
    # Pass in an options hash to instantiate the object and set the data
    # attributes. First iterates through the hash converting nested hashes
    # and arrays of hashes into other PYR::ResponseObjects if possible.
    # Hash keys that are not defined as attributes with `attr_accessor`
    # or `lr_has_many` will not be accessible in the parent object.
    def initialize(opts = {}, &block)
      new_opts = opts.each_with_object({}) do |(key, val), memo|
        memo[key] = convert_json_object_to_pyr_resource(key, val) || val
      end
      super(new_opts, &block)
    end

    # The controller name, based on the object's class name.
    def controller
      @controller ||= self.class.to_s.split('::').last.tableize
    end

    #
    def call
      PYR.call self
    end

    private

    # If the attribute key is a valid plural or singular resource,
    # e.g. `"reps"` or `"rep"`, use the values as options hashes to
    # instantiate PYR::ResponseObjects.
    def convert_json_object_to_pyr_resource(key, val)
      if resources_include?(key) && val.is_a?(Array)
        objectify(key, val)
      elsif resources_include_singular?(key) && val.is_a?(Hash)
        new_response_object(key, val)
      end
    end

    # Check the `PYR_RESOURCES` constant for the plural version of `name`
    def resources_include_singular?(name)
      resources_include?(name.to_s.pluralize)
    end

    # Check the `PYR_RESOURCES` constant for `name`
    def resources_include?(name)
      PYR_RESOURCES.include?(name.to_sym)
    end

    # Iterate over an array and instantiate a PYR::ResponseObject from
    # each item in the collection.
    def objectify(name, array)
      array.map { |obj| "PYR::#{name.to_s.classify}".constantize.new(obj) }
    end

    # Instantiate a single PYR::ResponseObject from an options hash.
    def new_response_object(name, opts)
      "PYR::#{name.to_s.classify}".constantize.new(opts)
    end
    # end private
  end
end
