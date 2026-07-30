# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe EastingNorthingToLatLonService do
      describe "#run" do
        subject(:result) { described_class.run(easting, northing) }

        COORDINATE_REFERENCE_POINTS.each do |postcode, point|
          context "when given the easting and northing for #{postcode}" do
            let(:easting) { point[:easting] }
            let(:northing) { point[:northing] }

            it "returns the WGS84 latitude and longitude to within 0.0001 degrees", :aggregate_failures do
              expect(result[:latitude]).to be_within(0.0001).of(point[:latitude])
              expect(result[:longitude]).to be_within(0.0001).of(point[:longitude])
            end
          end
        end

        context "when the easting and northing are strings" do
          let(:easting) { "358130" }
          let(:northing) { "172688" }

          it "coerces them to floats and converts them", :aggregate_failures do
            expect(result[:latitude]).to be_within(0.0001).of(51.451616)
            expect(result[:longitude]).to be_within(0.0001).of(-2.603943)
          end
        end
      end
    end
  end
end
