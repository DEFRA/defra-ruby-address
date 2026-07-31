# frozen_string_literal: true

module DefraRuby
  module Address
    # Shifts latitude/longitude between the OSGB36 and WGS84 datums using the
    # 7-parameter Helmert transformation from the OS guide "A guide to
    # coordinate systems in Great Britain". Accurate to around 5 metres.
    #
    # The OSGB36 to WGS84 direction is ported from the breasal gem
    # (https://github.com/theodi/breasal, MIT licence, copyright 2013
    # pezholio), corrected to the published OS guide parameters. The reverse
    # direction just negates them.
    class HelmertTransformation
      AIRY_1830 = { a: 6_377_563.396, b: 6_356_256.909 }.freeze
      WGS84 = { a: 6_378_137.0, b: 6_356_752.3141 }.freeze

      ARC_SECOND_IN_RADIANS = Math::PI / 648_000

      # Translations (tx, ty, tz) in metres, scale change (s) in parts per
      # unit and rotations (rx, ry, rz) in radians, for the OSGB36 to WGS84
      # direction; negated they transform in the opposite direction.
      PARAMETERS = {
        tx: 446.448,
        ty: -125.157,
        tz: 542.060,
        s: -0.0000204894,
        rx: 0.1502 * ARC_SECOND_IN_RADIANS,
        ry: 0.2470 * ARC_SECOND_IN_RADIANS,
        rz: 0.8421 * ARC_SECOND_IN_RADIANS
      }.freeze

      def self.osgb36_to_wgs84(latitude, longitude)
        new(AIRY_1830, WGS84, 1).transform(latitude, longitude)
      end

      def self.wgs84_to_osgb36(latitude, longitude)
        new(WGS84, AIRY_1830, -1).transform(latitude, longitude)
      end

      def initialize(source_ellipsoid, target_ellipsoid, direction)
        @source_ellipsoid = source_ellipsoid
        @target_ellipsoid = target_ellipsoid
        @direction = direction
      end

      def transform(latitude, longitude)
        to_geodetic(apply_helmert(to_cartesian(latitude, longitude)))
      end

      private

      attr_reader :source_ellipsoid, :target_ellipsoid, :direction

      def to_cartesian(latitude, longitude)
        e_squared = eccentricity_squared(source_ellipsoid)
        phi = latitude * Math::PI / 180
        lambda = longitude * Math::PI / 180
        nu = source_ellipsoid[:a] / Math.sqrt(1.0 - (e_squared * (Math.sin(phi)**2)))

        [nu * Math.cos(phi) * Math.cos(lambda),
         nu * Math.cos(phi) * Math.sin(lambda),
         (1.0 - e_squared) * nu * Math.sin(phi)]
      end

      def apply_helmert(cartesian)
        x, y, z = cartesian
        scale = 1.0 + parameter(:s)
        rx = parameter(:rx)
        ry = parameter(:ry)
        rz = parameter(:rz)

        [parameter(:tx) + (scale * x) - (rz * y) + (ry * z),
         parameter(:ty) + (rz * x) + (scale * y) - (rx * z),
         parameter(:tz) - (ry * x) + (rx * y) + (scale * z)]
      end

      def to_geodetic(cartesian)
        x, y, z = cartesian
        e_squared = eccentricity_squared(target_ellipsoid)
        p = Math.hypot(x, y)
        phi = Math.atan(z / (p * (1.0 - e_squared)))

        10.times do
          nu = target_ellipsoid[:a] / Math.sqrt(1.0 - (e_squared * (Math.sin(phi)**2)))
          phi = Math.atan((z + (e_squared * nu * Math.sin(phi))) / p)
        end

        [phi * 180 / Math::PI, Math.atan2(y, x) * 180 / Math::PI]
      end

      def parameter(key)
        direction * PARAMETERS[key]
      end

      def eccentricity_squared(ellipsoid)
        a = ellipsoid[:a]
        b = ellipsoid[:b]
        ((a * a) - (b * b)) / (a * a)
      end
    end
  end
end
