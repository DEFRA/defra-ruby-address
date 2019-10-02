# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe Response do
      subject(:response) { described_class.new(response_exe) }

      let(:successful) { -> { [{ "postcode" => "BS1 5AH" }] } }
      let(:errored) { -> { raise "Boom!" } }

      describe "#successful?" do
        context "when the response throws an error" do
          let(:response_exe) { errored }

          it "returns false" do
            expect(response).to_not be_successful
          end
        end

        context "when the response doesn't throw an error" do
          let(:response_exe) { successful }

          it "returns true" do
            expect(response).to be_successful
          end
        end
      end

      describe "#results" do
        context "when the response throws an error" do
          let(:response_exe) { errored }

          it "returns an empty array" do
            expect(response.results).to eq([])
          end
        end

        context "when the response does not throw an error" do
          let(:response_exe) { successful }

          it "returns a JSON array" do
            expect(response.results).to be_instance_of(Array)
            expect(response.results[0]).to be_instance_of(Hash)
            expect(response.results[0]["postcode"]).to eq("BS1 5AH")
          end
        end
      end

      describe "#error" do
        context "when the response throws an error" do
          let(:response_exe) { errored }

          it "returns the error" do
            expect(response.error).to be_a(StandardError)
          end
        end

        context "when the response don't throw an error" do
          let(:response_exe) { successful }

          it "returns a nil object" do
            expect(response.error).to be_nil
          end
        end
      end
    end
  end
end
