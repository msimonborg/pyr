# frozen_string_literal: true

module PYR
  # The Zcta is the response object that carries the data for
  # a single Zip Code Tabulation Area.
  class Zcta < ResponseObject
    lr_has_many :districts, :reps

    lr_attr_accessor :self, :zcta
  end
end
