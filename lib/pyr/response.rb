require 'httparty'

module PYR
  class Response
    attr_accessor :body, :url, :code, :message, :headers

    def initialize(url)
      self.url    = url
      payload     = HTTParty.get(url)
      self.body   = payload.parsed_response
      self.code    = payload.code
      self.message = payload.message
      self.headers = payload.headers
    end
  end
end
