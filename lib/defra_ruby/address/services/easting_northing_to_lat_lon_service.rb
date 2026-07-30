# frozen_string_literal: true

module DefraRuby
  module Address
    # Converts a British National Grid easting and northing to a WGS84
    # latitude and longitude. Accurate to around 5 metres.
    class EastingNorthingToLatLonService < BaseService
      def run(easting, northing)
        osgb36_latitude, osgb36_longitude = TransverseMercatorProjection.easting_northing_to_lat_lon(
          Float(easting), Float(northing)
        )
        latitude, longitude = HelmertTransformation.osgb36_to_wgs84(osgb36_latitude, osgb36_longitude)

        { latitude: latitude, longitude: longitude }
      end
    end
  end
end
