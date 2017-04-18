# PYR
[![Gem Version](https://badge.fury.io/rb/pyr.svg)](https://badge.fury.io/rb/pyr)
[![Code Climate](https://codeclimate.com/github/msimonborg/pyr/badges/gpa.svg)](https://codeclimate.com/github/msimonborg/pyr)
[![Coverage Status](https://coveralls.io/repos/github/msimonborg/pyr/badge.svg?branch=master)](https://coveralls.io/github/msimonborg/pyr?branch=master)
[![Build Status](https://travis-ci.org/msimonborg/pyr.svg?branch=master)](https://travis-ci.org/msimonborg/pyr)

PYR makes integrating data from the [Phone Your Rep API](https://www.github.com/phoneyourrep/phone-your-rep-api) into your Ruby project as easy as pie.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pyr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pyr

## Usage

### Querying by location
```ruby
response = PYR.call :reps do |r|
  r.lat  = 44.5588028
  r.long = -72.5778415
end

response.path
=> "reps?lat=44.5588028&long=-72.5778415"

## or ##

response = PYR.call(:reps) { |r| r.address = 'Vermont' }

response.path
=> "reps?address=Vermont"

response.code
=> 200

response.reason_phrase
=> "OK"

response.headers
=> { ... }

response.body
=> { ... }

reps = response.objects
=> #<PYR::RepRelation [#<PYR::Rep ...>]>

reps.first.official_full
=> "Bernard Sanders"

reps.first.office_locations_count
=> 3

reps.first.office_locations.first.phone
=> "802-748-9269"
```

### Querying the full index and narrowing with scopes
```ruby
response = PYR.call :reps
# is equivalent to
response = PYR.reps

reps = response.objects

reps.count
=> 536

reps.democrat.count
=> 243

reps.senators.count
=> 100

reps.democrat.senators.count
=> 46

reps.where official_full: 'Bernard Sanders'
=> #<PYR::RepRelation [#<PYR::Rep self: "https://phone-your-rep.herokuapp.com/api/beta/reps/S000033", state: #<PYR::State:0x007fdb11d42580>, district: nil, active: true, bioguide_id: "S000033", official_full: "Bernard Sanders", role: "United States Senator", party: "Independent", senate_class: "01", last: "Sanders", first: "Bernard", middle: nil, nickname: "Bernie", suffix: nil, contact_form: "http://www.sanders.senate.gov/contact/", url: "https://www.sanders.senate.gov", photo: "https://phoneyourrep.github.io/images/congress/450x550/S000033.jpg", twitter: "SenSanders", facebook: "senatorsanders", youtube: "senatorsanders", instagram: nil, googleplus: nil, twitter_id: "29442313", facebook_id: nil, youtube_id: "UCD_DaKNac0Ta-2PeHuoQ1uA", instagram_id: nil, office_locations_count: 3>]>

reps.independent.where { |r| r.state.name == 'Vermont' }.first
=> #<PYR::Rep self: "https://phone-your-rep.herokuapp.com/api/beta/reps/S000033", state: #<PYR::State:0x007fdb11d42580>, district: nil, active: true, bioguide_id: "S000033", official_full: "Bernard Sanders", role: "United States Senator", party: "Independent", senate_class: "01", last: "Sanders", first: "Bernard", middle: nil, nickname: "Bernie", suffix: nil, contact_form: "http://www.sanders.senate.gov/contact/", url: "https://www.sanders.senate.gov", photo: "https://phoneyourrep.github.io/images/congress/450x550/S000033.jpg", twitter: "SenSanders", facebook: "senatorsanders", youtube: "senatorsanders", instagram: nil, googleplus: nil, twitter_id: "29442313", facebook_id: nil, youtube_id: "UCD_DaKNac0Ta-2PeHuoQ1uA", instagram_id: nil, office_locations_count: 3>
```

### Querying by ID
```ruby
bernie = PYR.call(:reps, 'S000033').objects.first
=> #<PYR::Rep ... >
```

### Querying by Object
```ruby
office = PYR.reps('S000033').objects.first.office_locations.district.first
=> #<PYR::OfficeLocation city: "Burlington", rep: "https://phone-your-rep.herokuapp.com/api/beta/reps/S000033", active: true, office_id: "S000033-burlington", bioguide_id: "S000033", office_type: "district", distance: nil, building: "", address: "1 Church St.", suite: "3rd Floor", city: "Burlington", state: "VT", zip: "05401", phone: "802-862-0697", fax: "802-860-6370", hours: "", latitude: 44.4802081, longitude: -73.2130702, v_card_link: "https://phone-your-rep.herokuapp.com/v_cards/S000033-burlington", downloads: 14, qr_code_link: "https://s3.amazonaws.com/phone-your-rep-images/S000033_burlington.png">

# Pass in the object itself as the param to PYR.call
office == PYR.call(office).objects.first
=> true

# Or use #call on the object itself
office == office.call.objects.first
=> true
```

### Querying by Phone Your Rep URI
```ruby
rep = PYR.reps { |r| r.address = 'vermont' }.objects.representatives.first

uri = rep.district.self
=> "https://phone-your-rep.herokuapp.com/api/beta/districts/5000"

district = PYR.call(uri).objects.first

=> #<PYR::District self: "https://phone-your-rep.herokuapp.com/api/beta/districts/5000", full_code: "5000", code: "00", state_code: "50">
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/msimonborg/pyr.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
