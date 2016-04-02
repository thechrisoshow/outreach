# encoding: utf-8

module Outreach
  module Errors
    class Unauthorized < StandardError; end

    def check_for_error(status_code)
      # raise error if status code isn't 200
      case status_code.to_i
      when 401
        raise Unauthorized.new("Unauthorized")
      end
    end
  end
end