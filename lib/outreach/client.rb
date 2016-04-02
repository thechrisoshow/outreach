module Outreach
  class Client
    def initialize(api_token)
      @api_token = api_token
    end

    def prospect
      Outreach::ProspectFinder.new(request)
    end

    private

    def request
      Request.new(@api_token)
    end
  end
end