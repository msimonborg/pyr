# frozen_string_literal: true

require 'httparty'

module PYR
  # The object returned by a request call to the API.
  class Response
    attr_reader :body, :uri, :code, :message, :headers, :objects, :controller

    def initialize(base_url: nil, resource: nil, response_object: nil)
      assign_url_and_controller(base_url, resource, response_object)
      fetch_and_parse_payload
      parse_objects
    end

    def assign_url_and_controller(base_url, resource, response_object)
      if base_url && resource
        @controller = resource.controller
        @uri        = "#{base_url}#{resource}"
      elsif base_url
        @controller = base_url.sub(API_BASE_URI, '').split('/').first
        @uri        = base_url
      elsif response_object
        @controller = response_object.controller
        @uri        = response_object.self
      end
    end

    def fetch_and_parse_payload
      payload  = HTTParty.get uri
      @body    = payload.parsed_response
      @code    = payload.code
      @message = payload.message
      @headers = payload.headers
    end

    def parse_objects
      @objects = Parser.parse(body, controller)
    end
  end
end
