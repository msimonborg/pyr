# frozen_string_literal: true

module PYR
  class Param
    attr_reader :name, :value

    def initialize(name, value, id: nil)
      @id = id == true ? true : false
      @name  = name
      @value = value
    end

    def id?
      @id
    end

    def to_s
      url_value = value.to_s.tr('#;\'""', '').gsub(' ', '%20')
      id? ? "/#{value}" : "#{name}=#{url_value}&"
    end
  end
end
