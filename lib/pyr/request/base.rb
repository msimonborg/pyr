# frozen_string_literal: true

module PYR
  class Request
    # Base request object
    class Base
      attr_accessor :controller

      def initialize
        self.controller = self.class.to_s.downcase.split('::').last
      end

      def to_s
        "#{controller}#{params}"
      end

      def params; end
    end
  end
end
