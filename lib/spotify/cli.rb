# frozen_string_literal: true

require 'thor'
require 'spotify'
require 'csv'

module Spotify
  class CLI < Thor
    desc 'download_playlists', 'Downloads all user\'s playlists into zipped csv'

    def download_playlists
      say('Welcome to the Spotify playlist CLI')
      user = Spotify::User.default
      playlist_ids = find_playlist_ids(user)
      say("User: #{user.display_name} has #{playlist_ids.count} playlists.")
      continue = ask('Do you want to continue? (yes/no)')
      return if continue.eql?('no')

      playlist_ids.each_with_index do |playlist_id, index|
        say("Exporting playlist n.#{index}...")
        Spotify::PlaylistCsv.create!(user_id: user.id, playlist_id: playlist_id)
      end

      say("Your exported playlists can be found in /tmp/playlists")
    end

    private

    def find_playlist_ids(user)
      playlist_ids = user.playlists(limit: 50, offset: 50).map(&:id).flatten
      continue = playlist_ids.count.eql?(50)
      counter = 0

      while continue
        counter += 1
        offset = 50 * counter
        playlist_ids.concat(user.playlists(limit: 50, offset: offset))
        continue = playlist_ids.count > 50 && (playlist_ids.count % 50).zero?
      end

      playlist_ids
    end
  end
end
