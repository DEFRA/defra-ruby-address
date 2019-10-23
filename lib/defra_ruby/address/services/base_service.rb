# frozen_string_literal: true

require "json"
require "rest-client"

module DefraRuby
  module Address
    class BaseAddressService

      def self.run(postcode)
        new(postcode).run
      end

      def initialize(postcode)
        @postcode = postcode
      end

      def run
        Response.new(response_exe)
      end

      private

      OS_PLACES_ADDRESS_LOOKUP_NO_MATCH_ERROR_MSG = "Parameters are not valid"

      attr_reader :postcode

      def response_exe
        lambda do
          begin
            response = RestClient::Request.execute(
              method: :get,
              url: url,
              timeout: DefraRuby::Address.configuration.timeout
            )
            JSON.parse(response)
          rescue RestClient::BadRequest => e
            raise NoMatchError if no_match_error?(e&.response)

            raise e
          end
        end
      end

      def no_match_error?(response)
        return false unless response
        return true if JSON.parse(response)["error"]["message"] == OS_PLACES_ADDRESS_LOOKUP_NO_MATCH_ERROR_MSG

        false
      end
    end
  end
end
