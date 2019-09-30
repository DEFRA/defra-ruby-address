# frozen_string_literal: true

module DefraRuby
  module Address
    class Configuration
      attr_accessor :host

      def initialize
        @timeout = nil
      end
    end
  end
end
