require 'httparty'
require 'json'

module Outreach

  class Request

    include HTTParty
    include Errors

    def initialize(access_token=nil)
      @access_token = access_token
    end

    def get(url, query={})
      attrs = {
        query: query, headers: auth_header
      }
      attrs[:debug_output] = $stdout if Outreach.debug
      response = HTTParty.get(url, attrs)
      parse_response(response)
    end

    def post(url, params)
      response_format = params.delete(:response_format) || :json
      attrs = {
        body: params.to_json, headers: auth_header
      }
      attrs[:debug_output] = $stdout if Outreach.debug
      response = HTTParty.post(url, attrs)
      parse_response(response, response_format)
    end

    def patch(url, params)
      response_format = params.delete(:response_format) || :json
      attrs = {
        body: params.to_json, headers: auth_header
      }
      attrs[:debug_output] = $stdout if Outreach.debug
      response = HTTParty.patch(url, attrs)
      parse_response(response, response_format)
    end

    def delete(url)
      attrs = {
        headers: auth_header
      }
      attrs[:debug_output] = $stdout if Outreach.debug
      response = HTTParty.delete(url, attrs)
      parse_response(response)
    end

    private

    def parse_response(response, response_format=:json)
      check_for_error(response.response.code, response.body)
      display_debug(response.body)
      if response_format == :json
        JSON.parse(response.body.to_s)
      else
        response.body.to_s
      end
    end

    def display_debug(response)
      if Outreach.debug
        puts "-" * 20 + " DEBUG " + "-" * 20
        puts response
        puts "-" * 18 + " END DEBUG " + "-" * 18
      end
    end

    def auth_header
      headers = { 'Content-Type' => 'application/json' }
      headers["Authorization"] = "Bearer #{@access_token}" if @access_token
      headers
    end
  end
end
