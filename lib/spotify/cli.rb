# frozen_string_literal: true

require 'thor'
require 'spotify'
require 'csv'

module Spotify
  class CLI < Thor
    desc 'download_playlists', 'Downloads spotify user\'s playlists in csvs'

    def download_playlists
      say('Welcome to the Spotify playlist CLI')
      user = Spotify::User.new
      say("User: #{user.spotify_user.display_name} has #{user.playlists.count} playlists.")
      continue = ask('Do you want to continue? (yes/no)')
      return if continue.eql?('no')

      user.playlists.each_with_index do |playlist, index|
        say("Exporting playlist n.#{index}: #{playlist.name}")
        Spotify::PlaylistCsv.create!(playlist: playlist)
      end

      say('Your exported playlists can be found in /tmp/playlists')
      say('Thank you for using Spotiplay, come back anytime!')
    end
  end
end
