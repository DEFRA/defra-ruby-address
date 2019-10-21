# frozen_string_literal: true

require_relative "address/configuration"
require_relative "address/no_match_error"
require_relative "address/response"

require_relative "address/services/base_address_service"
require_relative "address/services/os_places_address_lookup_service"

module DefraRuby
  module Address
    class << self
      # attr_accessor :configuration

      def configure
        yield(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
        @configuration
      end
    end
  end
end
