# Defra Ruby Address

[![Build Status](https://travis-ci.com/DEFRA/defra-ruby-address.svg?branch=master)](https://travis-ci.com/DEFRA/defra-ruby-address)
[![Maintainability](https://api.codeclimate.com/v1/badges/1a0b68efe00098e0734f/maintainability)](https://codeclimate.com/github/DEFRA/defra-ruby-address/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1a0b68efe00098e0734f/test_coverage)](https://codeclimate.com/github/DEFRA/defra-ruby-address/test_coverage)
[![security](https://hakiri.io/github/DEFRA/defra-ruby-address/master.svg)](https://hakiri.io/github/DEFRA/defra-ruby-address/master)
[![Gem Version](https://badge.fury.io/rb/defra_ruby_address.svg)](https://badge.fury.io/rb/defra_ruby_address)
[![Licence](https://img.shields.io/badge/Licence-OGLv3-blue.svg)](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

Currently there are a number of Rails based digital services in Defra, talking to a set of address lookups. Behind the scenes these lookups all talk to [OS Places](https://developer.ordnancesurvey.co.uk/os-places-api), yet still for whatever reason we have multiple projects fulfilling this role 😩!

This means we are often duplicating code across our digital services, or are stuck having to maintain different environments and code purely to handle working with different lookups. In each case they are doing the same thing, taking a postcode or UPRN, querying OS Places, and returning the results as JSON.

So we've created this gem 😁!

It's aim is to help us

- start to reduce the duplication across projects
- be consistent in how we peform a lookup
- be consistent in the response we get and how we handle it
- move towards a single solution for address lookups across projects

## Installation

Add this line to your application's Gemfile

```ruby
gem "defra_ruby_address"
```

And then update your dependencies by calling

```bash
bundle install
```

## Configuration

You just need to let the gem know the host uri for the address lookup.

```ruby
# config/initializers/defra_ruby_address.rb
require "defra_ruby/address"

DefraRuby::Address.configure do |config|
  config.host = "http://localhost:9002"
end
```

## Usage

The gem interfaces with 2 address lookups

- [OS Places Address Lookup](https://github.com/DEFRA/os-places-address-lookup)
- [EA Address Facade](https://github.com/DEFRA/ea-address-facade) (repo is private)

The **EA Address Facade** has 2 versions, so the gem provides 3 separate services a host app can use.

### Response object

Each service responds with a `DefraRuby::Address::Response` object. It has the following attributes

```ruby
response.successful?
response.results
response.error
```

If the call is successful then

- `successful?()` will be `true`
- `results` will contain an array of JSON objects each representing an address. The format of the JSON will depend on the service called
- `error` will be `nil`

If the call is unsuccessful (the query errored or no match was found) then

- `successful?()` will be `false`
- `areas` will be `[]` (an empty array)
- `error` will contain the error

If it's a runtime error, or an error when calling the lookup `error` will contain whatever error was raised.

If it's because no match was found `error` will contain an instance of `DefraRuby::Address::NoMatchError`.

### OS Places Address Lookup

This was the first address lookup, built for the [Waste Carriers Registration Service](https://github.com/DEFRA/ruby-services-team/tree/master/services/wcr).

```ruby
response = DefraRuby::Address::OsPlacesAddressLookupService.run("BS1 5AH")

puts response.results.first["uprn"] # "340116"
```

The expected format of each result is

```json
{
  "moniker"=>"340116",
  "uprn"=>"340116",
  "lines"=>[
    "ENVIRONMENT AGENCY",
    "DEANERY ROAD"
  ],
  "town"=>"BRISTOL",
  "postcode"=>"BS1 5AH",
  "easting"=>"358205",
  "northing"=>"172708",
  "country"=>"",
  "dependentLocality"=>"",
  "dependentThroughfare"=>"",
  "administrativeArea"=>"BRISTOL",
  "localAuthorityUpdateDate"=>"",
  "royalMailUpdateDate"=>"",
  "partial"=>"ENVIRONMENT AGENCY, HORIZON HOUSE, DEANERY ROAD, BRISTOL, BS1 5AH",
  "subBuildingName"=>"",
  "buildingName"=>"HORIZON HOUSE",
  "thoroughfareName"=>"DEANERY ROAD",
  "organisationName"=>"ENVIRONMENT AGENCY",
  "buildingNumber"=>"",
  "postOfficeBoxNumber"=>"",
  "departmentName"=>"",
  "doubleDependentLocality"=>""
}
```

### EA Address Facade v1.0

> Not yet implemented

This was the second address lookup, built as a means of trying to ensure all services follow the Environment Agency address standard. Its also included general performance and security updates.

This version is currently used by the [Waste Exemptions Registration service](https://github.com/DEFRA/ruby-services-team/tree/master/services/wex) and the [Flood Risk Activity Exemptions service](https://github.com/DEFRA/ruby-services-team/tree/master/services/frae)

### EA Address Facade v1.1

> Not yet implemented

This was an iteration of the EA Address Facade. Mainly the format of the request changed as the lookup had been redesigned to run as a single instance for multiple services, whilst allowing each service to differentiate where the calls were coming from.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

<http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3>

The following attribution statement MUST be cited in your products and applications when using this information.

> Contains public sector information licensed under the Open Government license v3

### About the license

The Open Government Licence (OGL) was developed by the Controller of Her Majesty's Stationery Office (HMSO) to enable information providers in the public sector to license the use and re-use of their information under a common open licence.

It is designed to encourage use and re-use of information freely and flexibly, with only a few conditions.
