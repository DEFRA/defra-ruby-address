# frozen_string_literal: true

module DefraRuby
  module Address
    class Configuration
      attr_accessor :timeout, :host, :client_id, :key

      def initialize
        @timeout = 3
        @client_id = 0
        @key = "client1"
      end
    end
  end
end
