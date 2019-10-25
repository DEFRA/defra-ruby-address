# frozen_string_literal: true

require "json"
require "rest-client"

module DefraRuby
  module Address
    class BaseService
      def self.run(attrs = nil)
        new.run(attrs)
      end
    end
  end
end
