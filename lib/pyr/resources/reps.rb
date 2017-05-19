# frozen_string_literal: true

module PYR
  class Resource
    # Resource object for sending requests to the /reps resource of the API
    class Reps < Resource
      include GeoFindable

      # Read the state param
      attr_reader :state

      # Read the district param
      attr_reader :district

      # Read the party param
      attr_reader :party

      # Read the chamber param
      attr_reader :chamber

      # Set the state param. Can be the full name or two-letter abbreviation.
      #
      # @param name [String]
      #
      # @api public
      #
      # @example
      #   PYR.call :reps do |r|
      #     r.state = 'texas'
      #   end
      # Resulting URI
      #   'https://phone-your-rep.herokuapp.com/api/beta/reps?lat=45.0&long=-45.0'
      def state=(name)
        @state = Param.new(:state, name)
        params << @state
      end

      # Set the district param. Accepts the two-digit district code or
      # four-digit full code.
      #
      # @param code [String]
      #
      # @api public
      #
      # @example
      #   PYR.call :reps do |r|
      #     r.district = '5000'
      #   end
      def district=(code)
        @district = Param.new(:district, code)
        params << @district
      end

      # Set the party param
      #
      # @param name [String]
      #
      # @api public
      #
      # @example
      #   PYR.call :reps do |r|
      #     r.party = 'democrat'
      #   end
      def party=(name)
        @party = Param.new(:party, name)
        params << @party
      end

      # Set the chamber param
      #
      # @param chamber [String]
      #
      # @api public
      #
      # @example
      #   PYR.call :reps do |r|
      #     r.chamber = 'lower'
      #   end
      def chamber=(chamber)
        @chamber = Param.new(:chamber, chamber)
        params << @chamber
      end
    end
  end
end
