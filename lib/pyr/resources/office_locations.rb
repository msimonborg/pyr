# frozen_string_literal: true

module PYR
  class Resource
    # Request object for sending requests to the /office_locations
    # resource of the API
    class OfficeLocations < Resource
      include GeoFindable

      # Read the radius param
      attr_reader :radius

      # Set the radius param : integer
      # Needs to be accompanied by :address or :lat & :long.
      # When doing a geo search for office_locations the API returns
      # a set that is sorted by distance to the request location.
      # The radius param narrows down the geo search for office_locations to
      # only those within the specified radius in miles.
      # Without specifying the radius, the method will return all
      # 1,900 - 2,000 active office_locations for Congress sorted by distance,
      # which is seldom what you want.
      #
      # Usage:
      #   PYR.office_locations do |r|
      #     r.lat    = 45.0
      #     r.long   = -70.0
      #     r.radius = 100
      #   end
      def radius=(integer)
        @radius = Param.new(:radius, integer)
        params << @radius
      end
    end
  end
end
