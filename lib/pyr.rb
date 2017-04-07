# frozen_string_literal: true

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

# PYR provides an easy interface to the Phone Your Rep API,
# converting the data payloads into Plain Old Ruby Objects.
module PYR
  API_BASE_URL = 'https://phone-your-rep.herokuapp.com/api/beta/'

  PYR_RESOURCES = %i[
    reps
    office_locations
    states
    districts
    zctas
  ].freeze

  ActiveSupport::Inflector.inflections do |inflect|
    inflect.irregular 'zcta', 'zctas'
  end

  def self.call(resource, id = nil)
    if resource.is_a?(ResponseObject)
      request_object = { response_object: resource }
    elsif resource.to_s.include? API_BASE_URL
      request_object = { base_url: resource }
    else
      resource = Request.build(resource, id)
      yield resource if block_given?
      request_object = { base_url: API_BASE_URL, resource: resource }
    end
    Response.new request_object
  end
end
