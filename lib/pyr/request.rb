# frozen_string_literal: true

module PYR
  # The request class determines based on the :resource parameter which
  # subclass to call for constructing the query to the API.
  class Request
    API_URL = 'https://phone-your-rep.herokuapp.com/'

    attr_accessor :resource

    def self.call(resource)
      request = new(resource)
      yield request
    end

    def initialize(resource)
      self.resource = resource
    end
  end
end
