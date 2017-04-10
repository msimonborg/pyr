# frozen_string_literal: true

module PYR
  class Resource
    # Request object for sending requests to the /reps resource of the API
    class Reps < Resource
      attr_reader :lat, :long, :address, :generate

      def lat=(value)
        @lat = Param.new(:lat, value)
        params << @lat
      end

      def long=(value)
        @long = Param.new(:long, value)
        params << @long
      end

      def address=(value)
        @address = Param.new(:address, value)
        params << @address
      end

      def generate=(value)
        @generate = Param.new(:generate, value)
        params << @generate
      end
    end
  end
end
