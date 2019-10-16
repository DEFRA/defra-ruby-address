# frozen_string_literal: true

module DefraRuby
  module Address
    class Configuration
      attr_accessor :timeout, :host

      def initialize
        @timeout = 3
      end
    end
  end
end
