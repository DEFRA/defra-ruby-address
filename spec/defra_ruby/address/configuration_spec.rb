# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe Configuration do
      it "sets the appropriate default config settings" do
        fresh_config = described_class.new

        expect(fresh_config.timeout).to eq(3)
        expect(fresh_config.host).to be_nil
        expect(fresh_config.client_id).to eq(0)
        expect(fresh_config.key).to eq("client1")
      end
    end
  end
end
