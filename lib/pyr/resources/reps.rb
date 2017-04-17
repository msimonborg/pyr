# frozen_string_literal: true

module PYR
  class Resource
    # Resource object for sending requests to the /reps resource of the API
    class Reps < Resource
      include GeoFindable
    end
  end
end
