# frozen_string_literal: true

module PYR
  # Defines the #to_s method for request params.
  # Will handle the conversion differently depending on if
  # it is an ID param e.g. controller/:id
  class Param
    # www.example.com/path?name=value
    attr_reader :name, :value

    # Set the param `name` and `value`, and whether it's an ID
    def initialize(name, value, id: nil)
      @id    = !id.nil?
      @name  = name
      @value = value
    end

    # Is the param an ID param?
    def id?
      @id
    end

    # Format the param for the URI
    def to_s
      url_value = value.to_s.tr('#;\'""', '').gsub(' ', '%20')
      id? ? "/#{value}" : "#{name}=#{url_value}"
    end
  end
end
