# frozen_string_literal: true

module PYR
  # The District is the response object that carries the data for
  # a single congressional district.
  class District < ResponseObject
    lr_attr_accessor :self, :full_code, :code, :state_code
  end
end
