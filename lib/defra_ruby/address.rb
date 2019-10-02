# frozen_string_literal: true

require_relative "address/configuration"
require_relative "address/response"

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
