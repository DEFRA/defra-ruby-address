# frozen_string_literal: true

module DefraRuby
  module Address
    class Response
      attr_reader :error, :results

      def initialize(response_exe)
        @success = true
        @results = []
        @error = nil

        capture_response(response_exe)
      end

      def successful?
        success
      end

      private

      attr_reader :success

      def capture_response(response_exe)
        @results = response_exe.call
      rescue StandardError => e
        @error = e
        @success = false
      end
    end
  end
end
