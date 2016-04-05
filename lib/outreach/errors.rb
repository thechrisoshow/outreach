# encoding: utf-8

module Outreach
  module Errors
    class Unauthorized < StandardError; end

    def check_for_error(status_code, response_body)
      # raise error if status code isn't 200
      case status_code.to_i
      when 401
        description = begin
          JSON.parse(response_body).fetch("error_description")
        rescue
          "Unauthorized"
        end
        raise Unauthorized.new(description)
      end
    end
  end
end