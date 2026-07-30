# frozen_string_literal: true

# ONS postcode database values (easting, northing, WGS84 latitude and
# longitude) used to verify the coordinate conversion services against
# independent reference data.
COORDINATE_REFERENCE_POINTS = {
  "BS1 5AH" => { easting: 358_130, northing: 172_688, latitude: 51.451616, longitude: -2.603943 },
  "LS1 1UR" => { easting: 429_833, northing: 434_079, latitude: 53.802177, longitude: -1.548522 },
  "NE1 7RU" => { easting: 424_693, northing: 565_147, latitude: 54.980327, longitude: -1.615727 },
  "TR19 7AA" => { easting: 134_340, northing: 25_043, latitude: 50.066019, longitude: -5.713697 },
  "SW1A 1AA" => { easting: 529_090, northing: 179_645, latitude: 51.501010, longitude: -0.141563 },
  "NR30 5DN" => { easting: 652_390, northing: 311_882, latitude: 52.645932, longitude: 1.729544 }
}.freeze
