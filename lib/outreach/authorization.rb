require 'uri'

module Outreach
  class Authorization
    API_URL =  "https://api.outreach.io/oauth/token"

    attr_reader :token, :refresh_token, :expires_in

    def initialize(attrs)
      @token = attrs[:access_token]
      @refresh_token = attrs[:refresh_token]
      @expires_in = attrs[:expires_in]
    end

    def self.authorization_url
      url = "https://api.outreach.io/oauth/authorize"
      params = {
        client_id:     Outreach.application_identifier,
        redirect_uri:  Outreach.redirect_uri,
        response_type: 'code',
        scope:         Outreach.scopes
      }
      url + "?" + URI.encode_www_form(params)
    end

    def self.create(authorization_code)
      params = {
        client_id:     Outreach.application_identifier,
        client_secret: Outreach.application_secret,
        redirect_uri:  Outreach.redirect_uri,
        grant_type:    'authorization_code',
        code:          authorization_code
      }
      response = Request.new.post(API_URL, params)
      new(response)
    end
  end
end
