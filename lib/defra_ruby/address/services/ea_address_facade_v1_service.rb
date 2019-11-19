# frozen_string_literal: true

module DefraRuby
  module Address
    class EaAddressFacadeV1Service < BaseService

      PARAM_NAME = "postcode"

      def run(postcode)
        request = EaAddressFacadeRequest.new(PARAM_NAME)
        request.execute(postcode)
      end

    end
  end
end
