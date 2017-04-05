# frozen_string_literal: true

module PYR
  class Resource
    # Request object for sending requests to the /reps resource of the API
    class Reps < Resource
      attr_reader :lat, :long, :address, :generate

      def params
        "#{id}?#{lat}#{long}#{address}#{generate}"
      end

      def lat=(value)
        @lat = Param.new(:lat, value)
      end

      def long=(value)
        @long = Param.new(:long, value)
      end

      def address=(value)
        @address = Param.new(:address, value)
      end

      def generate=(value)
        @generate = Param.new(:generate, value)
      end
    end
  end
end
