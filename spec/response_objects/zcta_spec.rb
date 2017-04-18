# frozen_string_literal: true

describe 'PYR::Zcta' do
  before(:all) do
    @zcta = PYR::Zcta.new

    @attributes = [:self, :zcta]

    @collections = [:districts, :reps]
  end

  it 'is a LazyRecord::Base object' do
    expect(@zcta).to be_a(LazyRecord::Base)
  end

  it 'responds to attribute methods' do
    @attributes.each do |attr|
      expect(@zcta).to respond_to(attr)
      expect(@zcta).to respond_to("#{attr}=")
    end
  end

  it 'has_many districts' do
    add_district = lambda do
      @zcta.districts << PYR::District.new
    end

    add_non_district = lambda do
      @zcta.districts << Object.new
    end

    message = 'object must be of type PYR::District'

    expect(@zcta.districts).to be_a(LazyRecord::Relation)
    expect(&add_district).not_to raise_error
    expect(&add_non_district).to raise_error(ArgumentError, message)
  end

  it 'has_many reps' do
    add_rep = lambda do
      @zcta.reps << PYR::Rep.new
    end

    add_non_rep = lambda do
      @zcta.reps << Object.new
    end

    message = 'object must be of type PYR::Rep'

    expect(@zcta.reps).to be_a(LazyRecord::Relation)
    expect(&add_rep).not_to raise_error
    expect(&add_non_rep).to raise_error(ArgumentError, message)
  end
end
