# frozen_string_literal: true

require 'lazy_record'

module PYR
  # The ResponseObject is the parent class of all objects instantiated
  # from the response body.
  class ResponseObject < LazyRecord::Base
    def initialize(opts = {})
      new_opts = opts.inject({}) do |memo, (key, val)|
        memo[key] = case key
                    when 'office_locations'
                      val.map { |obj| OfficeLocation.new(obj) }
                    when 'reps'
                      val.map { |obj| Rep.new(obj) }
                    else
                      val
                    end
        memo
      end
      super(new_opts)
    end

    def controller
      @controller ||= self.class.to_s.split('::').last.tableize
    end
  end
end
