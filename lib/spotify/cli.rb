# frozen_string_literal: true

require 'thor'
require 'spotify'
require 'csv'

module Spotify
  class CLI < Thor
    PLAYLIST_LIMIT = 50
    desc 'download_playlists', 'Downloads all user\'s playlists into zipped csv'

    def download_playlists
      say('Welcome to the Spotify playlist CLI')
      user = Spotify::User.default
      playlists = find_playlists(user)
      say("User: #{user.display_name} has #{playlists.count} playlists.")
      continue = ask('Do you want to continue? (yes/no)')
      return if continue.eql?('no')

      playlists.each_with_index do |playlist, index|
        say("Exporting playlist n.#{index}: #{playlist.name}...")
        Spotify::PlaylistCsv.create!(playlist: playlist)
      end

      say("Your exported playlists can be found in /tmp/playlists")
    end

    private

    def find_playlists(user)
      playlists = user.playlists(limit: PLAYLIST_LIMIT)
      continue = playlists.count.eql?(PLAYLIST_LIMIT)
      counter = 0

      while continue
        counter += 1
        offset = 50 * counter
        new_playlists = user.playlists(limit: PLAYLIST_LIMIT, offset: offset)
        playlists.concat(new_playlists)
        continue = !new_playlists.count.zero? && (playlists.count % PLAYLIST_LIMIT).zero?
      end

      playlists
    end
  end
end
