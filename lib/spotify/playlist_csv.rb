# frozen_string_literal: true

module Spotify
  class PlaylistCsv
    CSV_HEADER = %w[song_id song_name artist_name album_name].freeze

    class << self
      def create!(user_id:, playlist_id:)
        @playlist = Spotify::Playlist.new(user_id: user_id, playlist_id: playlist_id)

        CSV.open(@playlist.path, 'wb', headers: CSV_HEADER) do |csv|
          @playlist.tracks.each do |track|
            csv << [track.id, track.name, track.artists&.first&.name, track.album&.name]
          end
        end
      end
    end
  end
end
