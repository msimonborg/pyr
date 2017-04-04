# frozen_string_literal: true

module PYR
  class Request
    # Request object for sending requests to the /reps resource of the API
    class Reps < Base
      attr_writer :lat, :long, :address, :generate, :bioguide_id

      def params
        "#{bioguide_id}?#{lat}#{long}#{address}#{generate}"
      end

      def bioguide_id
        "/#{@bioguide_id}" if @bioguide_id
      end

      def lat
        "lat=#{@lat}&" if @lat
      end

      def long
        "long=#{@long}&" if @long
      end

      def address
        "address=#{@address.tr!('.,#', '').gsub!(' ', '%20')}&" if @address
      end

      def generate
        "generate=#{@generate}&" if @generate
      end
    end
  end
end
