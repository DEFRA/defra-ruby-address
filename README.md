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

## Usage

> Coming once we add some functionality

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
