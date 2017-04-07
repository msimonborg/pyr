# frozen_string_literal: true

module PYR
  # The Request module determines based on the :resource parameter which
  # Resource subclass to call for constructing the query to the API, and
  # returns an instance of that class.
  module Request
    def self.build(resource, id = nil)
      new_resource(resource, id) if PYR_RESOURCES.include?(resource.to_sym)
    end

    def self.new_resource(resource, id)
      "PYR::Resource::#{resource.to_s.camelize}".constantize.new(resource, id)
    end
  end
end
