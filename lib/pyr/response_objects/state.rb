# frozen_string_literal: true

module PYR
  # The State is the response object that carries the data for
  # a single US State.
  class State < ResponseObject
    lr_attr_accessor :self, :state_code, :name, :abbr
  end
end
