# encoding: utf-8

module Outreach
  module Errors
    class Unauthorized < StandardError; end

    def check_for_error(status_code, response_body)
      response_hash = JSON.parse(response_body)
      if response_hash['errors'].present? &&
          response_hash['errors']['status'].present?
        status_code = response_hash['errors']['status']
      end

      # raise error if status code isn't 200
      case status_code.to_i
      when 401
        unauthorized_error(response_body)
      end
    end

    private

    def unauthorized_error(response_body)
      description = begin
        JSON.parse(response_body).fetch("error_description")
      rescue
        "Unauthorized"
      end
      raise Unauthorized.new(description)
    end

  end
end