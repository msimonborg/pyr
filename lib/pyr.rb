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
# There is one class method on the PYR module, ::call.
#
# The method takes two arguments: :resource and :id. The resource
# is the API resource, or controller name, that you want to
# query. The name must be in plural form. The options are 'reps',
# 'office_locations', 'states', 'districts', and 'zctas' (Zip Code
# Tabulation Areas).
#
# The :id is the primary key id of a particular object. Each
# resource has its own data attribute as ID.
#
#   ids = {
#     reps: :bioguide_id,
#     office_locations: :office_id,
#     states: :state_code,
#     districts: :full_code,
#     zctas: :zcta
#   }
#
# The ::call method takes a block, to which it yields an object
# inherited from the PYR::Resource class. You can then pass params to
# the PYR::Resource object. The particular descendant of PYR::Resource,
# and therefore the available params, depends on the resource/controller
# that you are querying.
#
# The return value of ::call is an instance of the PYR::Response class.
# You can call these methods on the object:
#
#   #objects => A collection, similar to an ActiveRecord Relation, of
#               objects descended from the PYR::ResponseObject superclass,
#               which have getter methods for each data attribute.
#               The objects may be nested inside other PYR::ResponseObjects,
#               e.g. a :rep has_one :state and has_many :office_locations.
#               The collection can be iterated over, and can be queried
#               similarly to how you would query in ActiveRecord, using the
#               #where method, which can take hash syntax for checking equality
#               of discreet attributes, or block syntax if you need to do
#               more complex comparisons. Some scopes are also available
#               depending on the resource, e.g. `reps.democratic.senators`
#
#   #uri => The URI that the request was sent to.
#
#   #body => The raw JSON data response
#
#   #code => The HTTP status code e.g. 200
#
#   #message => The HTTP status message e.g. 'OK'
#
#   #controller => The API controller that was hit e.g. :reps, :zctas etc...
#
#   #headers => A hash containing the HTTP response headers
#
# ==== Examples
#
#   response = PYR.call(:reps) { |r| r.address = 'vermont' }
#
#   response.body # => { ... }
#   response.uri # => 'https://phone-your-rep.herokuapp.com/api/beta/reps?address=vermont'
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
module PYR
  # The base URI for all requests
  API_BASE_URI = 'https://phone-your-rep.herokuapp.com/api/beta/'

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
  # a particular PYR::ResponseObject itself to query that object's 'self' url;
  #
  # a valid Phone Your Rep URI beginning with the API_BASE_URI string value;
  #
  # or, perhaps most commonly, a resource name (String or Symbol) with
  # optional ID(String).
  def self.call(resource, id = nil)
    if resource.is_a?(ResponseObject)
      request_object = { response_object: resource }
    elsif resource.to_s.include? API_BASE_URI
      request_object = { base_url: resource }
    else
      resource = Request.build(resource, id)
      yield resource if block_given?
      request_object = { base_url: API_BASE_URI, resource: resource }
    end
    Response.new request_object
  end
end
