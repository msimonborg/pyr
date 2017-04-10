# frozen_string_literal: true

module PYR
  class Resource
    # Request object for sending requests to the /zctas resource of the API
    class Zctas < Resource
      attr_reader :reps

      def reps=(value)
        @reps = Param.new(:reps, value)
        params << @reps
      end
    end
  end
end
