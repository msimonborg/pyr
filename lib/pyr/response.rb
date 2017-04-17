# frozen_string_literal: true

module PYR
  # The object returned by a request call to the API.
  # == Example
  #     response = PYR.call :reps, 'S000033'
  #     # => #<PYR::Response:0x007fe8f90829f8 ... >
  class Response
    # Returns a hash of the Raw JSON response
    #     response.body # => { ... }
    attr_reader :body
    # Returns a string of the URI path
    # == Example
    #     response.path # => 'reps/S000033'
    attr_reader :path
    # Returns an integer of the  HTTP status code
    # == Example
    #     response.code # => 200
    attr_reader :code
    # Returns a string of the response HTTP reason phrase
    # == Example
    #     response.reason_phrase # => "OK"
    attr_reader :reason_phrase
    # Returns a hash of the response HTTP headers
    # == Example
    #     response.headers # => {"server"=>"Cowboy", "connection"=>"close", ... }
    attr_reader :headers
    # Returns a collection of PYR::ResponseObjects representing API objects
    # == Example
    #     response.objects
    #     # => #<PYR::RepRelation [#<PYR::Rep ... >]>
    #     response.objects.first.office_locations
    #     # => #<PYR::OfficeLocationRelation [#<PYR::OfficeLocation ... >]>
    attr_reader :objects
    # Returns a symbol representing the Responding API controller
    # == Example
    #     response.controller # => :reps
    attr_reader :controller

    def initialize(uri: nil, resource: nil, response_object: nil)
      assign_url_and_controller(uri, resource, response_object)
      fetch_and_parse_payload
      parse_objects
    end

    def assign_url_and_controller(uri, resource, response_object)
      if resource
        @controller = resource.controller
        @path       = resource.to_s
      elsif uri
        @controller = uri.sub!(API_BASE_URI, '').split('/').first
        @path       = uri
      elsif response_object
        @controller = response_object.controller
        @path       = response_object.self.sub(API_BASE_URI, '')
      end
    end

    def fetch_and_parse_payload
      response       = API_CONN.get path
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
