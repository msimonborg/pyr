# frozen_string_literal: true

describe 'Rep' do
  before(:all) do
    @rep = PYR::Rep.new

    @attributes = %i[
      self
      state
      district
      active
      bioguide_id
      official_full
      role
      party
      senate_class
      last
      first
      middle
      nickname
      suffix
      contact_form
      url
      photo
      twitter
      facebook
      youtube
      instagram
      googleplus
      twitter_id
      facebook_id
      youtube_id
      instagram_id
    ]

    @scopes = %i[
      republican
      democrat
      independent
      senators
      representatives
    ]
  end

  it 'is a LazyRecord::Base object' do
    expect(@rep).to be_a(LazyRecord::Base)
  end

  it 'responds to attribute methods' do
    @attributes.each do |attr|
      expect(@rep).to respond_to(attr)
      expect(@rep).to respond_to("#{attr}=")
    end
  end

  it 'has_many office_locations' do
    add_office_location = lambda do
      @rep.office_locations << PYR::OfficeLocation.new
    end

    add_non_office_location = lambda do
      @rep.office_locations << Object.new
    end

    message = 'object must be of type PYR::OfficeLocation'

    expect(@rep.office_locations).to be_a(LazyRecord::Relation)
    expect(&add_office_location).not_to raise_error
    expect(&add_non_office_location).to raise_error(ArgumentError, message)
  end

  it 'responds to scopes' do
    PYR::Rep.destroy_all

    scope_returns = {
      democrat:        PYR::Rep.new(party: 'Democrat'),
      republican:      PYR::Rep.new(party: 'Republican'),
      independent:     PYR::Rep.new(party: 'Independent'),
      representatives: PYR::Rep.new(role: 'United States Representative'),
      senators:        PYR::Rep.new(role: 'United States Senator')
    }

    @scopes.each do |scope|
      result = PYR::Rep.send(scope)
      expect(result).to be_a(LazyRecord::Relation)
      expect(result).to include(scope_returns[scope])
      expect(result.count).to be(1)
      expect(result).to respond_to(scope)
    end
  end
end
