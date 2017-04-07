
# frozen_string_literal: true

module PYR
  # Parses the response body and returns an array of response_objects.
  class Parser
    def parse(body, controller)
      if body.keys.first == 'self'
        klass = "PYR::#{controller.classify}".constantize
        LazyRecord::Relation.new model: klass, array: [klass.new(body)]
      else
        reduce_body(body)
      end
    end

    def reduce_body(body)
      body.reduce([]) do |memo, (key, value)|
        case key
        when 'reps'
          LazyRecord::Relation.new model: Rep,
                                   array: memo + value.map { |val| Rep.new(val) }
        when 'office_locations'
          LazyRecord::Relation.new model: OfficeLocation,
                                   array: memo + value.map { |val| OfficeLocation.new(val) }
        else
          memo
        end
      end
    end
  end
end
