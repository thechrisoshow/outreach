require "outreach/version"
require "outreach/errors"
require "outreach/request"
require "outreach/authorization"
require "outreach/client"
require "outreach/prospect"
require "outreach/service/prospect"

module Outreach
  class << self
    attr_accessor :application_identifier
    attr_accessor :application_secret
    attr_accessor :scopes
    attr_accessor :redirect_uri
    attr_accessor :debug
  end
end
