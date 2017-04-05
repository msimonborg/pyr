# frozen_string_literal: true

require 'lazy_record'

module PYR
  # The ResponseObject is the parent class of all objects instantiated
  # from the response body.
  class ResponseObject < LazyRecord::Base
    def initialize(opts = {})
      new_opts = opts.inject({}) do |memo, (key, val)|
        case key
        when 'office_locations'
          memo[key] = val.map { |obj| OfficeLocation.new(obj) }
        when 'reps'
          memo[key] = val.map { |obj| Rep.new(obj) }
        else
          memo[key] =  val
        end
        memo
      end
      super(new_opts)
    end
  end
end
