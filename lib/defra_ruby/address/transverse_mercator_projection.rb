# frozen_string_literal: true

module DefraRuby
  module Address
    # Converts between British National Grid easting/northing and OSGB36
    # latitude/longitude, a Transverse Mercator projection on the Airy 1830
    # ellipsoid. Variable names follow the terms in the OS guide "A guide to
    # coordinate systems in Great Britain".
    #
    # The easting/northing to lat/lon direction is ported from the breasal
    # gem (https://github.com/theodi/breasal, MIT licence, copyright 2013
    # pezholio). Breasal has no reverse conversion, so that direction comes
    # straight from the OS guide's forward projection formulae.
    class TransverseMercatorProjection
      A = HelmertTransformation::AIRY_1830[:a]
      B = HelmertTransformation::AIRY_1830[:b]
      E_SQUARED = ((A * A) - (B * B)) / (A * A)
      N = (A - B) / (A + B)

      F0 = 0.9996012717
      PHI0 = 49.0 * Math::PI / 180
      LAMBDA0 = -2.0 * Math::PI / 180
      E0 = 400_000.0
      N0 = -100_000.0

      def self.easting_northing_to_lat_lon(easting, northing)
        new.easting_northing_to_lat_lon(easting, northing)
      end

      def self.lat_lon_to_easting_northing(latitude, longitude)
        new.lat_lon_to_easting_northing(latitude, longitude)
      end

      def easting_northing_to_lat_lon(easting, northing)
        phi_prime = converged_phi_prime(northing)
        delta_e = easting - E0

        [latitude_from(phi_prime, delta_e) * 180 / Math::PI,
         longitude_from(phi_prime, delta_e) * 180 / Math::PI]
      end

      def lat_lon_to_easting_northing(latitude, longitude)
        phi = latitude * Math::PI / 180
        delta_lambda = (longitude * Math::PI / 180) - LAMBDA0

        [easting_from(phi, delta_lambda), northing_from(phi, delta_lambda)]
      end

      private

      def converged_phi_prime(northing)
        phi_prime = ((northing - N0) / (A * F0)) + PHI0

        loop do
          delta = northing - N0 - meridional_arc(phi_prime)
          break if delta < 0.001

          phi_prime += delta / (A * F0)
        end

        phi_prime
      end

      # The methods below are a straight port of the OS guide formulae; the
      # ABC metric counts every arithmetic operator, so is disabled for them.
      # rubocop:disable Metrics/AbcSize

      # M in the OS guide
      def meridional_arc(phi)
        delta_phi = phi - PHI0
        sum_phi = phi + PHI0

        B * F0 * (((1 + N + ((5.0 / 4) * (N**2)) + ((5.0 / 4) * (N**3))) * delta_phi) -
          (((3 * N) + (3 * (N**2)) + ((21.0 / 8) * (N**3))) * Math.sin(delta_phi) * Math.cos(sum_phi)) +
          ((((15.0 / 8) * (N**2)) + ((15.0 / 8) * (N**3))) * Math.sin(2 * delta_phi) * Math.cos(2 * sum_phi)) -
          (((35.0 / 24) * (N**3)) * Math.sin(3 * delta_phi) * Math.cos(3 * sum_phi)))
      end

      # Terms VII, VIII and IX in the OS guide
      def latitude_from(phi_prime, delta_e)
        tan = Math.tan(phi_prime)
        tan2 = tan**2
        nu = nu(phi_prime)
        rho = rho(phi_prime)
        eta_squared = (nu / rho) - 1.0

        vii = tan / (2 * rho * nu)
        viii = (tan / (24 * rho * (nu**3))) * (5 + (3 * tan2) + eta_squared - (9 * tan2 * eta_squared))
        ix = (tan / (720 * rho * (nu**5))) * (61 + (90 * tan2) + (45 * (tan2**2)))

        phi_prime - (vii * (delta_e**2)) + (viii * (delta_e**4)) - (ix * (delta_e**6))
      end

      # Terms X, XI, XII and XIIA in the OS guide
      def longitude_from(phi_prime, delta_e)
        sec = 1.0 / Math.cos(phi_prime)
        tan2 = Math.tan(phi_prime)**2
        nu = nu(phi_prime)

        x = sec / nu
        xi = (sec / (6 * (nu**3))) * ((nu / rho(phi_prime)) + (2 * tan2))
        xii = (sec / (120 * (nu**5))) * (5 + (28 * tan2) + (24 * (tan2**2)))
        xiia = (sec / (5040 * (nu**7))) * (61 + (662 * tan2) + (1320 * (tan2**2)) + (720 * (tan2**3)))

        LAMBDA0 + (x * delta_e) - (xi * (delta_e**3)) + (xii * (delta_e**5)) - (xiia * (delta_e**7))
      end

      # Terms IV, V and VI in the OS guide
      def easting_from(phi, delta_lambda)
        nu = nu(phi)
        rho = rho(phi)
        eta_squared = (nu / rho) - 1.0
        cos_phi = Math.cos(phi)
        tan2 = Math.tan(phi)**2

        iv = nu * cos_phi
        v = (nu / 6) * (cos_phi**3) * ((nu / rho) - tan2)
        vi = (nu / 120) * (cos_phi**5) * (5 - (18 * tan2) + (tan2**2) + (14 * eta_squared) - (58 * tan2 * eta_squared))

        E0 + (iv * delta_lambda) + (v * (delta_lambda**3)) + (vi * (delta_lambda**5))
      end

      # Terms I, II, III and IIIA in the OS guide
      def northing_from(phi, delta_lambda)
        nu = nu(phi)
        eta_squared = (nu / rho(phi)) - 1.0
        sin_phi = Math.sin(phi)
        cos_phi = Math.cos(phi)
        tan2 = Math.tan(phi)**2

        i = meridional_arc(phi) + N0
        ii = (nu / 2) * sin_phi * cos_phi
        iii = (nu / 24) * sin_phi * (cos_phi**3) * (5 - tan2 + (9 * eta_squared))
        iiia = (nu / 720) * sin_phi * (cos_phi**5) * (61 - (58 * tan2) + (tan2**2))

        i + (ii * (delta_lambda**2)) + (iii * (delta_lambda**4)) + (iiia * (delta_lambda**6))
      end
      # rubocop:enable Metrics/AbcSize

      def nu(phi)
        A * F0 * ((1.0 - (E_SQUARED * (Math.sin(phi)**2)))**-0.5)
      end

      def rho(phi)
        A * F0 * (1.0 - E_SQUARED) * ((1.0 - (E_SQUARED * (Math.sin(phi)**2)))**-1.5)
      end
    end
  end
end
