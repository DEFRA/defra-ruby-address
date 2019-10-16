# frozen_string_literal: true

module DefraRuby
  module Address
    class OsPlacesAddressLookupService < BaseAddressService

      private

      def url
        File.join(
          DefraRuby::Address.configuration.host,
          "/addresses?postcode=#{postcode}"
        )
      end
    end
  end
end
