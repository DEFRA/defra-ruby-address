# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe EaAddressFacadeV11Service do
      describe "#run" do
        before do
          DefraRuby::Address.configure { |c| c.host = "http://localhost:8005/" }
          stub_request(:get, url).to_return(status: code, body: body)
        end

        let(:client_id) { DefraRuby::Address.configuration.client_id }
        let(:key) { DefraRuby::Address.configuration.key }
        let(:postcode) { "BS1 5AH" }
        let(:url) { "http://localhost:8005/address-service/v1/addresses/postcode?client-id=#{client_id}&key=#{key}&query-string=#{postcode}" }
        let(:code) { 200 }
        let(:body) { File.read("spec/fixtures/ea_address_facade_v1_1_valid.json") }

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
          context "because it is not found" do
            let(:postcode) { "BS1 9XX" }
            let(:body) { File.read("spec/fixtures/ea_address_facade_v1_1_not_found.json") }

            it "returns a 'NoMatchError'" do
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
            let(:code) { 400 }
            let(:body) { File.read("spec/fixtures/ea_address_facade_v1_1_blank.json") }

            it "returns a failed response" do
              response = described_class.run(postcode)

              expect(a_request(:get, url)).to have_been_made.at_most_once

              expect(response).to be_a(Response)
              expect(response).to_not be_successful
              expect(response.results).to be_empty
              expect(response.error).to be_an_instance_of(RestClient::BadRequest)
            end
          end
        end
      end
    end
  end
end
