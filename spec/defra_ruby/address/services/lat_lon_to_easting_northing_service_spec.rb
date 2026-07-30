# frozen_string_literal: true

require "spec_helper"

module DefraRuby
  module Address
    RSpec.describe LatLonToEastingNorthingService do
      describe "#run" do
        subject(:result) { described_class.run(latitude, longitude) }

        COORDINATE_REFERENCE_POINTS.each do |postcode, point|
          context "when given the WGS84 latitude and longitude for #{postcode}" do
            let(:latitude) { point[:latitude] }
            let(:longitude) { point[:longitude] }

            it "returns the easting and northing to within 10 metres", :aggregate_failures do
              expect(result[:easting]).to be_within(10).of(point[:easting])
              expect(result[:northing]).to be_within(10).of(point[:northing])
            end
          end

          context "when round tripping the easting and northing for #{postcode}" do
            let(:converted) { EastingNorthingToLatLonService.run(point[:easting], point[:northing]) }
            let(:latitude) { converted[:latitude] }
            let(:longitude) { converted[:longitude] }

            it "returns an easting and northing within 10 metres of the originals", :aggregate_failures do
              expect(result[:easting]).to be_within(10).of(point[:easting])
              expect(result[:northing]).to be_within(10).of(point[:northing])
            end
          end
        end

        context "when the latitude and longitude are strings" do
          let(:latitude) { "51.451616" }
          let(:longitude) { "-2.603943" }

          it "coerces them to floats and converts them", :aggregate_failures do
            expect(result[:easting]).to be_within(10).of(358_130)
            expect(result[:northing]).to be_within(10).of(172_688)
          end
        end
      end
    end
  end
end
