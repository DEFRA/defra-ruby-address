# frozen_string_literal: true

module DefraRuby
  module Address
    class OsApiAddressLookupV1Service < BaseService

      # Mapping from OS API DPA field names to EaAddressFacade field names
      # rubocop:disable Layout/HashAlignment
      FIELD_MAPPING = {
        "UPRN"                           => "uprn",
        "ADDRESS"                        => "address",
        "ORGANISATION_NAME"              => "organisation",
        "BUILDING_NAME"                  => "premises",
        "THOROUGHFARE_NAME"              => "street_address",
        "DEPENDENT_LOCALITY"             => "locality",
        "POST_TOWN"                      => "city",
        "POSTCODE"                       => "postcode",
        "X_COORDINATE"                   => "x",
        "Y_COORDINATE"                   => "y",
        "BLPU_STATE_DATE"                => "blpu_state_date",
        "BLPU_STATE_CODE"                => "blpu_state_code",
        "POSTAL_ADDRESS_CODE"            => "postal_address_code",
        "LOGICAL_STATUS_CODE"            => "logical_status_code",
        "BLPU_STATE_CODE_DESCRIPTION"    => "blpu_state_code_description",
        "CLASSIFICATION_CODE"            => "classification_code",
        "CLASSIFICATION_CODE_DESCRIPTION" => "classification_code_description",
        "MATCH"                          => "match",
        "MATCH_DESCRIPTION"              => "match_description",
        "TOPOGRAPHY_LAYER_TOID"          => "topography_layer_toid",
        "PARENT_UPRN"                    => "parent_uprn",
        "LAST_UPDATE_DATE"               => "last_update_date",
        "STATUS"                         => "status",
        "ENTRY_DATE"                     => "entry_date",
        "POSTAL_ADDRESS_CODE_DESCRIPTION" => "postal_address_code_description",
        "USRN"                           => "usrn",
        "LANGUAGE"                       => "language"
      }.freeze
      # rubocop:enable Layout/HashAlignment

      DEFAULT_HOST = "https://api.os.uk/search/places/v1"

      def run(postcode)
        @postcode = postcode
        Response.new(response_exe)
      end

      private

      attr_reader :postcode

      def url
        host = DefraRuby::Address.configuration.host || DEFAULT_HOST

        File.join(
          host,
          "postcode?postcode=#{postcode}&key=#{DefraRuby::Address.configuration.key}"
        )
      end

      def response_exe
        lambda do
          response = RestClient::Request.execute(
            method: :get,
            url: url,
            timeout: DefraRuby::Address.configuration.timeout
          )
          parsed = JSON.parse(response)
          results = parsed["results"] || []

          raise DefraRuby::Address::NoMatchError if results.empty?

          results.map { |r| map_dpa_to_result(r["DPA"]) }
        end
      end

      def map_dpa_to_result(dpa)
        result = map_fields(dpa)
        result["uprn"] = result["uprn"]&.to_i
        result.merge(hardcoded_fields)
      end

      def map_fields(dpa)
        FIELD_MAPPING.each_with_object({}) do |(os_key, facade_key), hash|
          hash[facade_key] = dpa[os_key]
        end
      end

      def hardcoded_fields
        {
          "country" => "United Kingdom",
          "coordinate_system" => nil,
          "source_data_type" => "dpa",
          "lpi_logical_status_code" => nil,
          "lpi_logical_status_code_description" => nil
        }
      end

    end
  end
end
