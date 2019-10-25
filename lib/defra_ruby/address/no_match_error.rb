# frozen_string_literal: true

module DefraRuby
  module Address
    class NoMatchError < StandardError
      def initialize
        super("No match found")
      end
    end
  end
end
