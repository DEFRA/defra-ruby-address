# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe OsPlacesAddressLookupService do
      describe "#run" do
        before do
          DefraRuby::Address.configure { |c| c.host = "http://localhost:8005/" }
        end

        context "when the postcode is valid" do
          before { VCR.insert_cassette("os_places_postcode_valid") }
          after { VCR.eject_cassette }

          let(:postcode) { "BS1 5AH" }

          it "returns a successful response" do
            response = described_class.run(postcode)
            expect(response).to be_a(Response)
            expect(response.successful?).to eq(true)
            expect(response.results).not_to be_empty
          end
        end
      end

      context "when the postcode is invalid" do
        context "because it is not found" do
          before { VCR.insert_cassette("os_places_postcode_invalid_no_match") }
          after { VCR.eject_cassette }

          let(:postcode) { "BS1 9XX" }

          it "returns a failed response" do
            response = described_class.run(postcode)
            expect(response).to be_a(Response)
            expect(response).to_not be_successful
            expect(response.results).to be_empty
            expect(response.error).to_not be_nil
          end
        end

        context "because it is blank" do
          before { VCR.insert_cassette("os_places_postcode_invalid_blank") }
          after { VCR.eject_cassette }

          let(:postcode) { "" }

          it "returns a failed response" do
            response = described_class.run(postcode)
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
