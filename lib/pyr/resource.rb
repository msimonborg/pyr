# frozen_string_literal: true

module PYR
  # Resource and its subclasses accept attribute params and,
  # in conjunction with the Param class,
  # convert them to a URI friendly string
  class Resource
    attr_reader :id, :controller

    def initialize(controller, id)
      @controller = controller
      self.id     = id
    end

    def id=(value)
      @id = Param.new(:id, value, id: true) if value
    end

    def to_s
      "#{controller}#{id}?#{params.map(&:to_s).join('&')}"
    end

    def params
      @params ||= []
    end
  end
end
