# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe OsApiAddressLookupV1Service do
      describe "#run" do
        before do
          DefraRuby::Address.configure do |c|
            c.host = "https://api.os.uk/search/places/v1"
            c.key = "test_api_key"
          end
          stub_request(:get, url).to_return(status: code, body: body)
        end

        let(:postcode) { "BS1 5AH" }
        let(:url) { "https://api.os.uk/search/places/v1/postcode?postcode=#{postcode}&key=test_api_key" }
        let(:code) { 200 }
        let(:body) { File.read("spec/fixtures/os_api_address_lookup_v1_valid.json") }
        let(:response) { described_class.run(postcode) }

        it_behaves_like "handle request errors"

        context "when the postcode is valid" do
          it "returns a successful response", :aggregate_failures do
            expect(a_request(:get, url)).to have_been_made.at_most_once
            expect(response).to be_a(Response)
            expect(response.successful?).to be(true)
            expect(response.results).not_to be_empty
          end

          it "maps address fields to EaAddressFacade format" do
            expect(response.results.first).to include("uprn" => 340_116, "city" => "BRISTOL")
          end

          it "includes all expected EaAddressFacade keys" do
            expect(response.results.first.keys).to include("uprn", "address", "organisation", "premises")
          end

          it "sets hardcoded fields correctly" do
            expect(response.results.first).to include("country" => "United Kingdom", "source_data_type" => "dpa")
          end
        end

        context "when the postcode is invalid" do
          context "when it is not found" do
            let(:postcode) { "BS9 9RR" }
            let(:body) { File.read("spec/fixtures/os_api_address_lookup_v1_not_found.json") }

            it "returns a 'NoMatchError'", :aggregate_failures do
              expect(a_request(:get, url)).to have_been_made.at_most_once
              expect(response).to be_a(Response)
              expect(response).not_to be_successful
              expect(response.results).to be_empty
              expect(response.error).to be_an_instance_of(DefraRuby::Address::NoMatchError)
            end
          end

          context "when it is blank" do
            let(:postcode) { "" }
            let(:code) { 400 }
            let(:body) { File.read("spec/fixtures/os_api_address_lookup_v1_blank.json") }

            it "returns a failed response", :aggregate_failures do
              expect(a_request(:get, url)).to have_been_made.at_most_once
              expect(response).to be_a(Response)
              expect(response).not_to be_successful
              expect(response.results).to be_empty
              expect(response.error).to be_an_instance_of(RestClient::BadRequest)
            end
          end
        end
      end
    end
  end
end
