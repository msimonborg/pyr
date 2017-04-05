# frozen_string_literal: true

require 'httparty'

module PYR
  # The object returned by a request call to the API.
  class Response
    attr_reader :body, :url, :code, :message, :headers, :objects, :controller

    def initialize(base_url, resource)
      payload     = HTTParty.get("#{base_url}#{resource}")
      @url        = url
      @controller = resource.controller
      @body       = payload.parsed_response
      @code       = payload.code
      @message    = payload.message
      @headers    = payload.headers
      parse_objects
    end

    def parse_objects
      parser = Parser.new
      @objects = parser.parse(body, controller)
    end
  end
end
