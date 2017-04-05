# frozen_string_literal: true

module PYR
  class Resource
    attr_reader :id, :controller

    def initialize(controller, id)
      @controller = controller
      self.id     = id
    end

    def id=(value)
      @id = Param.new(:id, value, id: true)
    end

    def to_s
      "#{controller}#{params}"
    end

    def params
      "#{id}?"
    end
  end
end
