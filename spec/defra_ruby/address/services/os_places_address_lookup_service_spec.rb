# frozen_string_literal: true

require "spec_helper"
require "rest-client"

module DefraRuby
  module Address
    RSpec.describe OsPlacesAddressLookupService do
      describe "#run" do
        before do
          DefraRuby::Address.configure { |c| c.host = "http://localhost:8005/" }
        end

        context "when the postcode is valid" do
          let(:url) { "http://localhost:8005/addresses?postcode=#{postcode}" }
          let(:postcode) { "BS1 5AH" }

          before do
            address_json = [{
              "moniker" => "340116",
              "uprn" => "340116",
              "lines" => ["NATURAL ENGLAND", "DEANERY ROAD"],
              "town" => "BRISTOL",
              "postcode" => "BS1 5AH",
              "easting" => "358205",
              "northing" => "172708",
              "country" => "",
              "dependentLocality" => "",
              "dependentThroughfare" => "",
              "administrativeArea" => "BRISTOL",
              "localAuthorityUpdateDate" => "",
              "royalMailUpdateDate" => "",
              "partial" => "NATURAL ENGLAND, HORIZON HOUSE, DEANERY ROAD, BRISTOL, BS1 5AH",
              "subBuildingName" => "",
              "buildingName" => "HORIZON HOUSE",
              "thoroughfareName" => "DEANERY ROAD",
              "organisationName" => "NATURAL ENGLAND",
              "buildingNumber" => "",
              "postOfficeBoxNumber" => "",
              "departmentName" => "",
              "doubleDependentLocality" => ""
            }].to_json

            stub_request(:get, url)
              .to_return(status: 200, body: address_json)
          end

          it "returns a successful response" do
            response = described_class.run(postcode)

            expect(a_request(:get, url)).to have_been_made.at_most_once

            expect(response).to be_a(Response)
            expect(response.successful?).to eq(true)
            expect(response.results).not_to be_empty
          end
        end
      end

      context "when the postcode is invalid" do
        let(:url) { "http://localhost:8005/addresses?postcode=#{postcode}" }

        context "because it is not found" do
          let(:postcode) { "BS1 9XX" }
          before do
            stub_request(:get, url)
              .to_return(status: 400, body: '{"error":{"statuscode":400,"message":"Parameters are not valid"}}')
          end

          it "returns a failed response" do
            response = described_class.run(postcode)

            expect(a_request(:get, url)).to have_been_made.at_most_once

            expect(response).to be_a(Response)
            expect(response).to_not be_successful
            expect(response.results).to be_empty
            expect(response.error).to_not be_nil
          end
        end

        context "because it is blank" do
          before do
            stub_request(:get, url)
              .to_return(status: 400, body: '{"errors":["query param postcode may not be empty"]}')
          end

          let(:postcode) { "" }

          it "returns a failed response" do
            response = described_class.run(postcode)

            expect(a_request(:get, url)).to have_been_made.at_most_once

            expect(response).to be_a(Response)
            expect(response).to_not be_successful
            expect(response.results).to be_empty
            expect(response.error).to_not be_nil
          end
        end
      end
    end
  end
end
