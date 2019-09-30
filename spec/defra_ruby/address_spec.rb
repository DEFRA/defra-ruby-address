# frozen_string_literal: true

require "spec_helper"

RSpec.describe DefraRuby::Address do
  describe "VERSION" do
    it "is a version string in the correct format" do
      expect(DefraRuby::Address::VERSION).to be_a(String)
      expect(DefraRuby::Address::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end

  describe "#configuration" do
    context "when the host app has not provided configuration" do
      it "returns a DefraRuby::Address::Configuration instance" do
        expect(described_class.configuration).to be_an_instance_of(DefraRuby::Address::Configuration)
      end
    end

    context "when the host app has provided configuration" do
      let(:host) { "http://localhost:9012" }

      it "returns an DefraRuby::Address::Configuration instance with a matching host" do
        described_class.configure { |config| config.host = host }

        expect(described_class.configuration.host).to eq(host)
      end
    end
  end
end
