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

      say("Downloading playlists for user #{user.display_name}...")
      playlist_ids = find_playlist_ids(user)
      say("User: #{user.display_name} has #{playlist_ids.count} playlists.")
      continue = ask('Do you want to continue? (yes/no)')
      return if continue.eql?('no')

      playlist_ids.each do |playlist_id|
        playlist = RSpotify::Playlist.find(user.id, playlist_id)
        CSV.open("#{APP_ROOT}/tmp/playlists/#{Time.now.strftime('%C%m%d')}_#{playlist.name}.csv", 'wb',
                 headers: true) do |csv|
          csv << %w[song_id song_name artist_name album_name]
          playlist.tracks.each do |song|
            csv << [song.id, song.name, song.artists.first.name, song.album.name]
          end
        end
      end
    end

    private

    def find_playlist_ids(user)
      playlist_ids = user.playlists(limit: 50).map(&:id).flatten
      continue = playlist_ids.count.eql?(50)
      counter = 0

      while continue
        counter += 1
        offset = 50 * counter
        playlist_ids.concat(user.playlists(limit: 50, offset: offset))
        continue = (playlist_ids.count % 50).zero?
      end

      playlist_ids
    end
  end
end
