# frozen_string_literal: true

describe 'PYR::District' do
  before(:all) do
    @district = PYR::District.new

    @attributes = %i[self full_code code state_code]
  end

  it 'is a LazyRecord::Base object' do
    expect(@district).to be_a(LazyRecord::Base)
  end

  it 'responds to attribute methods' do
    @attributes.each do |attr|
      expect(@district).to respond_to(attr)
      expect(@district).to respond_to("#{attr}=")
    end
  end
end
