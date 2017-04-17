# frozen_string_literal: true

module PYR
  # The object returned by a request call to the API.
  class Response
    attr_reader :body, :uri, :code, :reason_phrase, :headers, :objects, :controller

    def initialize(base_url: nil, resource: nil, response_object: nil)
      assign_url_and_controller(base_url, resource, response_object)
      fetch_and_parse_payload
      parse_objects
    end

    def assign_url_and_controller(base_url, resource, response_object)
      if resource
        @controller = resource.controller
        @uri        = resource.to_s
      elsif base_url
        @controller = base_url.sub!(API_BASE_URI, '').split('/').first
        @uri        = base_url
      elsif response_object
        @controller = response_object.controller
        @uri        = response_object.self.sub(API_BASE_URI, '')
      end
    end

    def fetch_and_parse_payload
      response       = API_CONN.get uri
      @body          = response.body
      @code          = response.status
      @reason_phrase = response.reason_phrase
      @headers       = response.headers
    end

    def parse_objects
      @objects = Parser.parse(body, controller)
    end
  end
end
