# frozen_string_literal: true

describe 'PYR::OfficeLocation' do
  before(:all) do
    @office_location = PYR::OfficeLocation.new

    @attributes = %i[
      self
      city
      rep
      active
      office_id
      bioguide_id
      office_type
      distance
      building
      address
      suite
      city
      state
      zip
      phone
      fax
      hours
      latitude
      longitude
      v_card_link
      downloads
      qr_code_link
    ]

    @scopes = %i[district capitol]
  end

  it 'is a LazyRecord::Base object' do
    expect(@office_location).to be_a(LazyRecord::Base)
  end

  it 'responds to attribute methods' do
    @attributes.each do |attr|
      expect(@office_location).to respond_to(attr)
      expect(@office_location).to respond_to("#{attr}=")
    end
  end

  it 'responds to scopes' do
    PYR::OfficeLocation.destroy_all
    
    scope_returns = {
      district: PYR::OfficeLocation.new(office_type: 'district'),
      capitol:  PYR::OfficeLocation.new(office_type: 'capitol')
    }

    @scopes.each do |scope|
      result = PYR::OfficeLocation.send(scope)
      expect(result).to be_a(LazyRecord::Relation)
      expect(result).to include(scope_returns[scope])
      expect(result.count).to be(1)
      expect(result).to respond_to(scope)
    end
  end
end
