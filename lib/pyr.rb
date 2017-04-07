# frozen_string_literal: true

require 'pyr/param'
require 'pyr/parser'
require 'pyr/resource'
require 'pyr/resources/office_locations'
require 'pyr/resources/reps'
require 'pyr/response'
require 'pyr/response_object'
require 'pyr/response_objects/office_location'
require 'pyr/response_objects/rep'
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
end
