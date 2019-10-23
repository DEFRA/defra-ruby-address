# frozen_string_literal: true

require "json"
require "rest-client"

module DefraRuby
  module Address
    class BaseService
      def self.run(attrs = nil)
        if attrs
          new.run(attrs)
        else
          new.run
        end
      end
    end
  end
end
