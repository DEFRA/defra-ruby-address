# rubocop:disable Gemspec/RequiredRubyVersion
# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem"s version:
require "defra_ruby/address/version"

Gem::Specification.new do |spec|
  spec.name          = "defra_ruby_address"
  spec.version       = DefraRuby::Address::VERSION
  spec.authors       = ["Defra"]
  spec.email         = ["alan.cruikshanks@environment-agency.gov.uk"]
  spec.license       = "The Open Government Licence (OGL) Version 3"
  spec.homepage      = "https://github.com/DEFRA/defra-ruby-address"
  spec.summary       = "Defra ruby on rails address lookup gem"
  spec.description   = "Provides a single source of functionality for querying Defra's various address lookup services."

  spec.files = Dir["{bin,config,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  spec.require_paths = ["lib"]

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["rubygems_mfa_required"] = "true"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
          "public gem pushes."
  end

  # Use rest-client for external requests, eg. to Companies House
  spec.add_dependency "rest-client", "~> 2.0"
end
# rubocop:enable Gemspec/RequiredRubyVersion
