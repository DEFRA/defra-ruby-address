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

      attr_reader :postcode

      def response_exe
        lambda do
          response = RestClient::Request.execute(
            method: :get,
            url: url,
            timeout: DefraRuby::Address.configuration.timeout
          )
          JSON.parse(response)
        end
      end
    end
  end
end
