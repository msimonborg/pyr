# frozen_string_literal: true

describe 'PYR' do
  it 'calls the reps resource with PYR.call' do
    response = PYR.call(:reps) { |r| r.address = 'Vermont' }

    expect(response).to be_a(PYR::Response)
    expect(response.body['total_records']).to eq(response.objects.count)
    expect(response.objects.all? { |o| o.is_a?(PYR::Rep) }).to be(true)
  end

  it 'calls the reps resource with PYR.reps' do
    response = PYR.reps('S000033')

    expect(response).to be_a(PYR::Response)
    expect(response.objects.count).to eq(1)
    expect(response.objects.first).to be_a(PYR::Rep)
    expect(response.objects.first.official_full).to eq('Bernard Sanders')
  end

  it 'calls the zctas resource PYR.call' do
    response = PYR.call(:zctas, '90026') { |r| r.reps = true }

    expect(response).to be_a(PYR::Response)
    expect(response.objects.first).to be_a(PYR::Zcta)
    expect(response.objects.first.reps.first).to be_a(PYR::Rep)
    expect(response.objects.first.districts.first).to be_a(PYR::District)
  end

  it 'calls the zctas resource with PYR.zctas' do
    response = PYR.zctas('90026') { |r| r.reps = true }

    expect(response).to be_a(PYR::Response)
    expect(response.objects.first).to be_a(PYR::Zcta)
    expect(response.objects.first.reps.first).to be_a(PYR::Rep)
    expect(response.objects.first.districts.first).to be_a(PYR::District)
  end

  it 'calls the office_locations resource by location with PYR.call' do
    response = PYR.call(:office_locations) do |r|
      r.lat    = 42.0
      r.long   = -71.0
      r.radius = 100
    end

    expect(response).to be_a(PYR::Response)
    expect(response.body['total_records']).to eq(response.objects.count)
    expect(response.objects.count).to be < 100
    expect(response.objects.count).to be > 0
  end

  it 'calls the office_locations resource with PYR.office_locations' do
    response = PYR.office_locations('A000055-capitol')

    expect(response).to be_a(PYR::Response)
    expect(response.objects.count).to eq(1)
    expect(response.objects.first).to be_a(PYR::OfficeLocation)
  end

  it 'calls the states resource with PYR.states' do
    response = PYR.states('50')

    expect(response).to be_a(PYR::Response)
    expect(response.objects.count).to eq(1)
    expect(response.objects.first).to be_a(PYR::State)
    expect(response.objects.first.abbr).to eq('VT')
  end

  it 'calls the districts resource with PYR.districts' do
    response = PYR.districts('5000')

    expect(response).to be_a(PYR::Response)
    expect(response.objects.count).to eq(1)
    expect(response.objects.first).to be_a(PYR::District)
    expect(response.objects.first.state_code).to eq('50')
  end

  it 'can call the API with a valid URI' do
    response = PYR.call("#{PYR::API_BASE_URI.dup}reps/S000033")

    expect(response).to be_a(PYR::Response)
    expect(response.objects.count).to eq(1)
    expect(response.objects.first).to be_a(PYR::Rep)
    expect(response.objects.first.official_full).to eq('Bernard Sanders')
  end

  it 'can call the API by passing a PYR::ResponseObject to PYR.call' do
    object   = PYR.reps('S000033').objects.first
    response = PYR.call(object)

    expect(response).to be_a(PYR::Response)
    expect(response.objects.count).to eq(1)
    expect(response.objects.first).to be_a(PYR::Rep)
    expect(response.objects.first).to eq(object)
  end

  it 'can call the API by sending the #call method to a PYR::ResponseObject' do
    object   = PYR.reps('S000033').objects.first
    response = object.call

    expect(response).to be_a(PYR::Response)
    expect(response.objects.count).to eq(1)
    expect(response.objects.first).to be_a(PYR::Rep)
    expect(response.objects.first).to eq(object)
  end
end
