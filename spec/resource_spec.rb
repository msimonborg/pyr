# frozen_string_literal: true

describe 'Resource' do
  before(:all) do
    class TestResource < PYR::Resource
      include PYR::GeoFindable
    end

    @resource          = TestResource.new('test_resource', 1)
    @resource.lat      = 45.0
    @resource.long     = -70.0
    @resource.address  = '123 Main St.'
    @resource.generate = true
  end

  it 'returns its controller name with #controller' do
    expect(@resource.controller).to eq('test_resource')
  end

  it 'returns a PYR::Param with #id' do
    expect(@resource.id).to be_a(PYR::Param)
    expect(@resource.id.value).to eq(1)
    expect(@resource.id.id?).to be(true)
  end

  context 'other attributes' do
    it 'includes lat' do
      expect(@resource.lat).to be_a(PYR::Param)
      expect(@resource.lat.value).to eq(45.0)
      expect(@resource.lat.id?).to be(false)
    end

    it 'includes long' do
      expect(@resource.long).to be_a(PYR::Param)
      expect(@resource.long.value).to eq(-70.0)
      expect(@resource.long.id?).to be(false)
    end

    it 'includes address' do
      expect(@resource.address).to be_a(PYR::Param)
      expect(@resource.address.value).to eq('123 Main St.')
      expect(@resource.address.id?).to be(false)
    end

    it 'includes generate' do
      expect(@resource.generate).to be_a(PYR::Param)
      expect(@resource.generate.value).to be(true)
      expect(@resource.generate.id?).to be(false)
    end
  end

  it '#to_s formats the proper URI given the controller and params' do
    uri = 'test_resource/1?lat=45.0&long=-70.0&'\
          'address=123%20Main%20St.&generate=true'

    expect(@resource.to_s).to eq(uri)
  end
end
