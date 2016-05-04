module Outreach
  class Client
    def initialize(api_token)
      @api_token = api_token
    end

    def prospects
      Outreach::Service::Prospect.new(self)
    end

    def request
      Request.new(@api_token)
    end
  end
end
