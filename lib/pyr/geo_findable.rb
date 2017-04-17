# frozen_string_literal: true

module PYR
  # Shared params for resources that can be looked up by location.
  module GeoFindable
    # Read the lat param
    attr_reader :lat
    # Read the long param
    attr_reader :long
    # Read the address param
    attr_reader :address
    # Read the generate param
    attr_reader :generate

    # Set the lat param : float
    # Needs to be accompanied by :long.
    #
    # Usage:
    #   PYR.call :reps do |r|
    #     r.lat  = 45.0
    #     r.long = -70.0
    #   end
    # Resulting URI
    #   'https://phone-your-rep.herokuapp.com/api/beta/reps?lat=45.0&long=-45.0'
    def lat=(float)
      @lat = Param.new(:lat, float)
      params << @lat
    end

    # Set the long param : float
    # Needs to be accompanied by :lat.
    #
    # Usage:
    #   PYR.call :reps do |r|
    #     r.lat  = 45.0
    #     r.long = -70.0
    #   end
    #
    # Resulting URI
    #   'https://phone-your-rep.herokuapp.com/api/beta/reps?lat=45.0&long=-45.0'
    def long=(float)
      @long = Param.new(:long, float)
      params << @long
    end

    # Set the address param : string
    # :lat and :long take precedence
    #
    # Usage:
    #   PYR.call(:reps) { |r| r.address = '123 Main St., USA'}
    #
    # Resulting URI:
    #   'https://phone-your-rep.herokuapp.com/api/beta/reps?lat=45.0&long=-45.0'
    def address=(string)
      @address = Param.new(:address, string)
      params << @address
    end

    # Set the generate param : boolean
    #
    # By default making a call to the full index will return a cached
    # JSON file. The cached file is updated regularly (usually every day).
    # However, if you want to generate a fresh response directly from the
    # database, you can set :generate to true. The response will be much
    # slower, and in most cases will never be necessary. Has no effect
    # when used with either :address or :lat/:long
    #
    # Usage:
    #   PYR.call(:reps) { |r| r.generate = true }
    #
    # Resulting URI:
    #   'https://phone-your-rep.herokuapp.com/api/beta/reps?generate=true'
    def generate=(boolean)
      @generate = Param.new(:generate, boolean)
      params << @generate
    end
  end
end
