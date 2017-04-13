# frozen_string_literal: true

module PYR
  class Resource
    # Request object for sending requests to the /reps resource of the API
    class Reps < Resource
      # Read the params
      attr_reader :lat, :long, :address, :generate

      # Set the lat param : float
      # Needs to be accompanied by :long.
      #
      # Usage:
      #   PYR.call :reps do |r|
      #     r.lat  = 45.00000
      #     r.long = -45.00000
      #   end
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
      #     r.long = -45.0
      #   end
      #
      # Resulting URI: 'https://phone-your-rep.herokuapp.com/api/beta/reps?lat=45.0&long=-45.0'
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
      # Resulting URI: 'https://phone-your-rep.herokuapp.com/api/beta/reps?lat=45.0&long=-45.0'
      def address=(string)
        @address = Param.new(:address, string)
        params << @address
      end

      # Set the generate param : boolean
      #
      # By default making a call to the full :reps index will return a cached
      # JSON file. The cached file is updated regularly (usually every day).
      # However, if you want to generate a fresh response directly from the
      # database, you can set :generate to true. The response will be much
      # slower, and in most cases will never be necessary. Has no effect
      # when used with either :address or :lat/:long
      #
      # Usage:
      #   PYR.call(:reps) { |r| r.generate = true }
      #
      # Resulting URI: 'https://phone-your-rep.herokuapp.com/api/beta/reps?generate=true'
      def generate=(boolean)
        @generate = Param.new(:generate, boolean)
        params << @generate
      end
    end
  end
end
