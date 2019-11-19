# frozen_string_literal: true

module DefraRuby
  module Address
    class EaAddressFacadeRequest

      def initialize(param_name)
        @param_name = param_name
      end

      def execute(postcode)
        @postcode = postcode
        Response.new(response_exe)
      end

      private

      attr_reader :postcode, :param_name

      def url
        host = DefraRuby::Address.configuration.host
        client_id = DefraRuby::Address.configuration.client_id
        key = DefraRuby::Address.configuration.key

        File.join(
          host,
          "/address-service/v1/addresses/",
          "postcode?client-id=#{client_id}&key=#{key}&#{param_name}=#{postcode}"
        )
      end

      def response_exe
        lambda do
          response = RestClient::Request.execute(
            method: :get,
            url: url,
            timeout: DefraRuby::Address.configuration.timeout
          )
          results = JSON.parse(response)["results"]

          raise DefraRuby::Address::NoMatchError if results.empty?

          results
        end
      end

    end
  end
end
