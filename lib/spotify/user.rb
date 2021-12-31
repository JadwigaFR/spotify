# frozen_string_literal: true

require 'spotify/configuration'
require 'rspotify'
require 'pry'

module Spotify
  class User
    class AuthenticationError < StandardError; end

    def initialize(username = nil)
      configuration = Spotify::Configuration.new
      RSpotify.authenticate(configuration.client_id, configuration.client_secret)

      if username
        RSpotify::User.find(username)
      else
        RSpotify::User.find(configuration.username)
      end
    rescue RestClient::NotFound => e
      raise AuthenticationError, "Something went wrong in the authentication. Message: #{e.message}"
    end
  end
end
