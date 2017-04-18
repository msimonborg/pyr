# frozen_string_literal: true

# Copyright (c) 2017 M. Simon Borg

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'faraday'
require 'faraday_middleware'

require 'pyr/geo_findable'
require 'pyr/param'
require 'pyr/parser'
require 'pyr/resource'
require 'pyr/resources/districts'
require 'pyr/resources/office_locations'
require 'pyr/resources/reps'
require 'pyr/resources/states'
require 'pyr/resources/zctas'
require 'pyr/response'
require 'pyr/response_object'
require 'pyr/response_objects/district'
require 'pyr/response_objects/office_location'
require 'pyr/response_objects/rep'
require 'pyr/response_objects/state'
require 'pyr/response_objects/zcta'
require 'pyr/request'
require 'pyr/version'

# PYR wraps the Phone Your Rep API in an easy interface,
# converting the data payloads into Ruby objects.
#
# ==== Examples
#
#   response = PYR.call(:reps) { |r| r.address = 'vermont' }
#
#   response.body # => { ... }
#   response.path # => 'reps?address=vermont'
#   reps = response.objects
#   reps.count # => 3
#   reps.independent.senators.first.official_full # => "Bernard Sanders"
#
#   response = PYR.call :reps
#
#   response.objects.count # => 536
#   independent_senators = response.objects.independent.senators
#   vt_fav_son = independent_senators.where { |r| r.state.abbr == 'VT' }.first
#   vt_fav_son.official_full # => "Bernard Sanders"
#   vt_fav_son.bioguide_id # => "S000033"
#
#   response = PYR.call :reps, 'S000033'
#
#   response.objects.first.official_full # => "Bernard Sanders"
#
#   PYR.reps('S000033').objects.first.official_full # => "Bernard Sanders"
#
# Any of the following resources can be passed as the first argument to
# `PYR.call`, or called as a class method directly to the PYR module,
# as in the above example.
#
# Both options yield a resource to the block for setting params.
#   :reps, :office_locations, :states, :districts, :zctas
#
# So
#
#   PYR.call(:reps) { |r| r.address = 'vermont' }
#
# Is equivalent to
#
#   PYR.reps { |r| r.address = 'vermont' }
module PYR
  # The base URI for all requests
  API_BASE_URI = 'https://phone-your-rep.herokuapp.com/api/beta/'

  # Faraday API Connection
  API_CONN = Faraday.new url: API_BASE_URI do |conn|
    conn.response :json, content_type: /\bjson$/
    conn.response :yaml, content_type: /\byaml$/
    conn.adapter Faraday.default_adapter
  end

  # The API resources available to query
  PYR_RESOURCES = %i[
    reps
    office_locations
    states
    districts
    zctas
  ].freeze

  # ActiveSupport::Inflector is used to identify possible PYR
  # objects nested in the JSON data response.
  #
  # The inflector thinks the plural of 'zcta' is 'zcta', so we
  # register the correct inflection.
  ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular 'zcta', 'zctas'
  end

  # The main API interface. All the objects you will need to work
  # with are returned by this method.
  #
  # Arguments can be:
  #
  # * a particular PYR::ResponseObject itself to query that object's 'self' url;
  #
  # * a valid Phone Your Rep URI beginning with the API_BASE_URI string value;
  #
  # * or, perhaps most commonly, a resource name (String or Symbol) with
  #   optional ID(String).
  #
  # @return [Response]
  def self.call(resource, id = nil, &config_block)
    if resource.is_a?(ResponseObject)
      request_object = { response_object: resource }
    elsif resource.to_s.include? API_BASE_URI
      request_object = { uri: resource }
    else
      resource = Request.build(resource, id)
      config_block.call resource if block_given?
      request_object = { resource: resource }
    end
    Response.new request_object
  end

  # Call the :reps resource.
  #
  # @example
  #   PYR.reps { |r| r.address = '123 Main St, USA 12345' }
  #
  # @return [PYR::Response]
  def self.reps(id = nil, &config_block)
    call(:reps, id, &config_block)
  end

  # Call the :office_locations resource.
  #
  # @example
  #   PYR.office_locations { |r| r.address = '123 Main St, USA 12345' }
  #
  # @return [PYR::Response]
  def self.office_locations(id = nil, &config_block)
    call(:office_locations, id, &config_block)
  end

  # Call the :zctas resource.
  #
  # @example
  #   PYR.zctas('90026') { |r| r.reps = true }
  #
  # @return [PYR::Response]
  def self.zctas(id = nil, &config_block)
    call(:zctas, id, &config_block)
  end

  # Call the :states resource.
  #
  # @example
  #   PYR.states '50'
  #
  # @return [PYR::Response]
  def self.states(id = nil, &config_block)
    call(:states, id, &config_block)
  end

  # Call the :districts resource.
  #
  # @example
  #   PYR.districts '5000'
  #
  # @return [PYR::Response]
  def self.districts(id = nil, &config_block)
    call(:districts, id, &config_block)
  end
end
