# frozen_string_literal: true

require 'spotify/configuration'
require 'rspotify'
require 'pry'

module Spotify
  class User
    class AuthenticationError < StandardError; end
    PLAYLIST_LIMIT = 50
    attr_reader :playlists, :spotify_user

    def self.default
      RSpotify.authenticate(@@configuration.client_id, @@configuration.client_secret)
      RSpotify::User.find(@@configuration.username)
    rescue RestClient::NotFound => e
      raise AuthenticationError, "Something went wrong in the authentication. Message: #{e.message}"
    end

    def initialize
      @spotify_user = Spotify::User.default
      @playlists = find_playlists
    end

    private

    def find_playlists
      playlists = spotify_user.playlists(limit: PLAYLIST_LIMIT)
      continue = playlists.count.eql?(PLAYLIST_LIMIT)
      counter = 0

      while continue
        counter += 1
        offset = PLAYLIST_LIMIT * counter
        new_playlists = spotify_user.playlists(limit: PLAYLIST_LIMIT, offset: offset)
        playlists.concat(new_playlists)
        continue = !new_playlists.count.zero? && (playlists.count % PLAYLIST_LIMIT).zero?
      end

      playlists
    end
  end
end
