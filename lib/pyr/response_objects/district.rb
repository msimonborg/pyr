# frozen_string_literal: true

module PYR
  # The District is the response object that carries the data for
  # a single congressional district.
  #
  # Responds to the following attribute methods:
  #
  #   #self => The object's direct URI path
  #
  #   #full_code => Concatenation of the `state_code` and `district_code`.
  #                 A unique 4 digit identifier for each Congressional District,
  #                 and the primary key ID of the object.
  #
  #   #code => 2 digit district identifier. Not unique. The state must
  #            provide context to indicate the exact district.
  #            e.g. Minnesota's 4th district
  #
  #   #state_code => Unique 2 digit code for the State that contains
  #                  the district.
  class District < ResponseObject
    lr_attr_accessor :self, :full_code, :code, :state_code
  end
end
