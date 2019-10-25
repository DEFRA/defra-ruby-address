# frozen_string_literal: true

RSpec.shared_examples "handle request errors" do
  context "when there is a problem with the address lookup" do

    context "and the request times out" do
      before { stub_request(:get, url).to_timeout }

      it "returns a failed response" do
        response = described_class.run(postcode)

        expect(response).to be_a(DefraRuby::Address::Response)
        expect(response).to_not be_successful
        expect(response.results).to be_empty
        expect(response.error).to_not be_nil
      end
    end

    context "and the request returns an error" do
      before { stub_request(:get, url).to_raise(SocketError) }

      it "returns a failed response" do
        response = described_class.run(postcode)

        expect(response).to be_a(DefraRuby::Address::Response)
        expect(response).to_not be_successful
        expect(response.results).to be_empty
        expect(response.error).to_not be_nil
      end
    end
  end
end
