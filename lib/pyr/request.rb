# frozen_string_literal: true

require_relative 'resource'
require_relative 'resources/reps'

module PYR
  # The resources class determines based on the :resource parameter which
  # subclass to call for constructing the query to the API.
  class Request
    API_URL = 'https://phone-your-rep.herokuapp.com/api/beta/'

    attr_accessor :resource

    def self.call(resource, id = nil)
      if resource.is_a?(ResponseObject)
        request_object = { response_object: resource }
      else
        request  = new
        resource = request.build(resource, id)
        yield resource if block_given?
        request_object = { base_url: API_URL, resource: resource }
      end
      Response.new request_object
    end

    def build(resource, id = nil)
      case resource.to_sym
      when :reps
        Resource::Reps.new(resource, id)
      when :office_locations
        Resource::OfficeLocations.new(resource, id)
      end
    end
  end
end
