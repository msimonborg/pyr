# frozen_string_literal: true

module PYR
  # The resources class determines based on the :resource parameter which
  # subclass to call for constructing the query to the API.
  class Request
    attr_accessor :resource

    def self.call(resource, id = nil)
      if resource.is_a?(ResponseObject)
        request_object = { response_object: resource }
      elsif resource.to_s.include? API_BASE_URL
        request_object = { base_url: resource }
      else
        request  = new
        resource = request.build(resource, id)
        yield resource if block_given?
        request_object = { base_url: API_BASE_URL, resource: resource }
      end
      Response.new request_object
    end

    def build(resource, id = nil)
      new_resource(resource, id) if PYR_RESOURCES.include?(resource.to_sym)
    end

    def new_resource(resource, id)
      "PYR::Resource::#{resource.to_s.camelize}".constantize.new(resource, id)
    end
  end
end
