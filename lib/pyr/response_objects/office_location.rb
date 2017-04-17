
# frozen_string_literal: true

module PYR
  # The OfficeLocation is the response object that carries the data
  # for a single office location, which in turn is associated to a
  # rep in a `:rep has_many :office_locations` relationship.
  class OfficeLocation < ResponseObject
    lr_scope :capitol, -> { where office_type: 'capitol' }
    lr_scope :district, -> { where office_type: 'district' }

    attr_accessor :self,
                  :city,
                  :rep,
                  :active,
                  :office_id,
                  :bioguide_id,
                  :office_type,
                  :distance,
                  :building,
                  :address,
                  :suite,
                  :city,
                  :state,
                  :zip,
                  :phone,
                  :fax,
                  :hours,
                  :latitude,
                  :longitude,
                  :v_card_link,
                  :downloads,
                  :qr_code_link
  end
end
