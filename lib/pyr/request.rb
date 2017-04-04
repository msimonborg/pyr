# frozen_string_literal: true

require_relative 'request/base'
require_relative 'request/reps'

module PYR
  # The request class determines based on the :resource parameter which
  # subclass to call for constructing the query to the API.
  class Request
    API_URL = 'https://phone-your-rep.herokuapp.com/'

    attr_accessor :resource

    def self.call(resource)
      request         = new(resource)
      resource_object = request.build
      yield resource_object if block_given?
      response = Response.new "#{API_URL}#{resource_object.to_s}"
      response
    end

    def initialize(resource)
      self.resource = resource
    end

    def build
      case resource.to_sym
      when :reps
        Reps.new
      end
    end
  end
end
