
# frozen_string_literal: true

module PYR
  # Parses the response body and returns an array of response_objects.
  class Parser
    def parse(body, controller)
      if body.keys.first == 'self'
        klass = "PYR::#{controller.to_s.classify}".constantize
        LazyRecord::Relation.new model: klass, array: [klass.new(body)]
      else
        reduce_body(body)
      end
    end

    def reduce_body(body)
      body.reduce([]) do |memo, (key, value)|
        if PYR_RESOURCES.include?(key.to_sym)
          convert_to_relation(key, memo, value)
        else
          memo
        end
      end
    end

    def convert_to_relation(resource, memo, value)
      klass = "PYR::#{resource.classify}".constantize
      LazyRecord::Relation.new model: klass,
                               array: memo + value.map { |val| klass.new(val) }
    end
  end
end
