# frozen_string_literal: true

module DefraRuby
  module Address
    # Converts a WGS84 latitude and longitude to a British National Grid
    # easting and northing. Accurate to around 5 metres.
    class LatLonToEastingNorthingService < BaseService
      def run(latitude, longitude)
        osgb36_latitude, osgb36_longitude = HelmertTransformation.wgs84_to_osgb36(
          Float(latitude), Float(longitude)
        )
        easting, northing = TransverseMercatorProjection.lat_lon_to_easting_northing(
          osgb36_latitude, osgb36_longitude
        )

        { easting: easting, northing: northing }
      end
    end
  end
end
