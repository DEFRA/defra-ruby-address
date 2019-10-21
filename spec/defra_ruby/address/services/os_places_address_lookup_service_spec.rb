# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe OsPlacesAddressLookupService do
      describe "#run" do
        before do
          DefraRuby::Address.configure { |c| c.host = "http://localhost:8005/" }
          stub_request(:get, url).to_return(status: code, body: body)
        end

        let(:postcode) { "BS1 5AH" }
        let(:url) { "http://localhost:8005/addresses?postcode=#{postcode}" }
        let(:code) { 200 }
        let(:body) do
          [{
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
        end

        include_examples "handle request errors"

        context "when the postcode is valid" do

          it "returns a successful response" do
            response = described_class.run(postcode)

            expect(a_request(:get, url)).to have_been_made.at_most_once

            expect(response).to be_a(Response)
            expect(response.successful?).to eq(true)
            expect(response.results).not_to be_empty
          end
        end

        context "when the postcode is invalid" do
          let(:code) { 400 }

          context "because it is not found" do
            let(:postcode) { "BS1 9XX" }
            let(:body) { '{"error":{"statuscode":400,"message":"Parameters are not valid"}}' }

            it "returns a failed response" do
              response = described_class.run(postcode)

              expect(a_request(:get, url)).to have_been_made.at_most_once

              expect(response).to be_a(Response)
              expect(response).to_not be_successful
              expect(response.results).to be_empty
              expect(response.error).to be_an_instance_of(DefraRuby::Address::NoMatchError)
            end
          end

          context "because it is blank" do
            let(:postcode) { "" }
            let(:body) { '{"errors":["query param postcode may not be empty"]}' }

            it "returns a failed response" do
              response = described_class.run(postcode)

              expect(a_request(:get, url)).to have_been_made.at_most_once

              expect(response).to be_a(Response)
              expect(response).to_not be_successful
              expect(response.results).to be_empty
              expect(response.error).to_not be_an_instance_of(DefraRuby::Address::NoMatchError)
            end
          end
        end
      end
    end
  end
end
