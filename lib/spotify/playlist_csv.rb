# frozen_string_literal: true

module Spotify
  class PlaylistCsv
    CSV_HEADER = %w[song_id song_name artist_name album_name].freeze

    class << self
      def create!(playlist:)
        @playlist = Spotify::Playlist.new(playlist: playlist)

        CSV.open(@playlist.path, 'wb', headers: CSV_HEADER) do |csv|
          @playlist.tracks.each do |track|
            csv << [track.id, track.name, track.artists&.first&.name, track.album&.name]
          end
        end
      end
    end
  end
end
