# frozen_string_literal: true

require 'thor'
require 'spotify'
require 'csv'

module Spotify
  class CLI < Thor
    desc 'download_playlists', 'Downloads all user\'s playlists into zipped csv'
    def download_playlists
      puts 'Welcome to the Spotify playlist CLI'
      user = Spotify::User.default

      puts "Downloading playlists for user #{user.display_name}..."
      playlists = user.playlists
      puts "User: #{user.display_name} has #{playlists.count} playlists."
      playlists_ids = playlists.map(&:id)

      playlists_ids.each do |playlist_id|
        playlist = RSpotify::Playlist.find(user.id, playlist_id)
        path = File.expand_path("../../tmp/playlists/#{Time.now.strftime('%C%m%d')}_#{playlist.name}.csv",
                                File.dirname(__FILE__))
        CSV.open(path, 'wb', headers: true) do |csv|
          csv << %w[song_id song_name artist_name album_name]
          playlist.tracks.each do |song|
            csv << [song.id, song.name, song.artists.first.name, song.album.name]
          end
        end
      end
    end
  end
end
