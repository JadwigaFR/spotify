# frozen_string_literal: true

require 'spotify/configuration'
require 'rspotify'
require 'pry'

module Spotify
  class User
    class AuthenticationError < StandardError; end

    def self.default
      RSpotify.authenticate(@@configuration.client_id, @@configuration.client_secret)
      RSpotify::User.find(@@configuration.username)
    rescue RestClient::NotFound => e
      raise AuthenticationError, "Something went wrong in the authentication. Message: #{e.message}"
    end
  end
end
