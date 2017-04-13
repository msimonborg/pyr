# frozen_string_literal: true

module PYR
  class Resource
    # Resource object for sending requests to the /zctas resource of the API
    class Zctas < Resource
      # Read the reps param value
      attr_reader :reps

      # Set the 'reps' param value
      def reps=(value)
        @reps = Param.new(:reps, value)
        params << @reps
      end
    end
  end
end
