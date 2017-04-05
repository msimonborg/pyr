
# frozen_string_literal: true

module PYR
  # Parses the response body and returns an array of response_objects.
  class Parser
    def parse(body, controller)
      if body.keys.first == 'self'
        ["PYR::#{controller.classify}".constantize.new(body)]
      else
        reduce_body(body)
      end
    end

    def reduce_body(body)
      body.reduce([]) do |memo, (key, value)|
        case key
        when 'reps'
          memo + value.map { |val| Rep.new(val) }
        when 'office_locations'
          memo + value.map { |val| OfficeLocation.new(val) }
        else
          memo
        end
      end
    end
  end
end
