# frozen_string_literal: true

require_relative "address/configuration"

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
