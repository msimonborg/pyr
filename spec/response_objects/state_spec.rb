# frozen_string_literal: true

describe 'PYR::State' do
  before(:all) do
    @state = PYR::State.new

    @attributes = %i[self state_code name abbr]
  end

  it 'is a LazyRecord::Base object' do
    expect(@state).to be_a(LazyRecord::Base)
  end

  it 'responds to attribute methods' do
    @attributes.each do |attr|
      expect(@state).to respond_to(attr)
      expect(@state).to respond_to("#{attr}=")
    end
  end
end
