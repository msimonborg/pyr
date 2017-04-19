# frozen_string_literal: true

module PYR
  # Resource and its subclasses accept attribute params and,
  # in conjunction with instances of the Param class,
  # convert them to a URI friendly string.
  # When a block is passed to `PYR.call(name)`, it yields
  # a Resource object, on which param setter methods can be
  # called. The exact type of Resource that is yielded depends
  # on the name that is passed to the method.
  #
  # === Example
  #
  #   PYR.call(:reps) do |r| # yielding an instance of PYR::Resource::Reps
  #     r.address = 'Somewhere in the USA' # The `address` param is available
  #   end
  class Resource
    # Read the `id`
    attr_reader :id
    # Read the `controller`
    attr_reader :controller

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

    private

    def params
      @params ||= []
    end
  end
end
