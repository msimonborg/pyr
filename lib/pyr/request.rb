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
      request  = new
      resource = request.build(resource, id)
      yield resource if block_given?
      response = Response.new(API_URL, resource)
      response
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
