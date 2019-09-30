# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe Configuration do
      it "sets the appropriate default config settings" do
        fresh_config = described_class.new

        expect(fresh_config.host).to be_nil
      end
    end
  end
end
