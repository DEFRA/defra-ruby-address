# frozen_string_literal: true

module DefraRuby
  module Address
    class EaAddressFacadeV11Service < BaseService

      PARAM_NAME = "query-string"

      def run(postcode)
        request = EaAddressFacadeRequest.new(PARAM_NAME)
        request.execute(postcode)
      end

    end
  end
end
