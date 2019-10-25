# frozen_string_literal: true

module DefraRuby
  module Address
    class OsPlacesAddressLookupService < BaseService

      def run(postcode)
        @postcode = postcode
        Response.new(response_exe)
      end

      private

      OS_PLACES_ADDRESS_LOOKUP_NO_MATCH_ERROR_MSG = "Parameters are not valid"

      attr_reader :postcode

      def url
        File.join(
          DefraRuby::Address.configuration.host,
          "/addresses?postcode=#{postcode}"
        )
      end

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
            raise process_error(e)
          end
        end
      end

      def process_error(error)
        if JSON.parse(error.response)["error"]["message"] == OS_PLACES_ADDRESS_LOOKUP_NO_MATCH_ERROR_MSG
          error = NoMatchError.new
        end
      rescue StandardError
        error
      ensure
        error
      end
    end
  end
end
