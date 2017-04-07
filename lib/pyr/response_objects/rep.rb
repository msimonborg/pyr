# frozen_string_literal: true

module PYR
  # The Rep is the response object that carries the data for
  # a single elected representative.
  class Rep < ResponseObject
    lr_has_many :office_locations

    lr_scope :republican, -> { where party: 'Republican' }
    lr_scope :democratic, -> { where party: 'Democrat' }
    lr_scope :independent, -> { where party: 'Independent' }
    lr_scope :senators, -> { where role: 'United States Senator' }
    lr_scope :representatives, -> { where role: 'United States Representative' }

    lr_attr_accessor :self,
                     :state,
                     :active,
                     :bioguide_id,
                     :official_full,
                     :role,
                     :party,
                     :senate_class,
                     :last,
                     :first,
                     :middle,
                     :nickname,
                     :suffix,
                     :contact_form,
                     :url,
                     :photo,
                     :twitter,
                     :facebook,
                     :youtube,
                     :instagram,
                     :googleplus,
                     :twitter_id,
                     :facebook_id,
                     :youtube_id,
                     :instagram_id
  end
end
