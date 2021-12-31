# frozen_string_literal: true

module Spotify
  class Playlist
    TRACK_LIMIT = 100
    attr_reader :playlist, :path

    def initialize(playlist:)
      @playlist = playlist
      @path = file_path(playlist)
    end

    def tracks
      tracks = playlist.tracks(limit: TRACK_LIMIT)
      continue = tracks.count.eql?(TRACK_LIMIT)
      counter = 0

      while continue
        counter += 1
        offset = TRACK_LIMIT * counter
        new_tracks = playlist.tracks(limit: TRACK_LIMIT, offset: offset)
        tracks.concat(new_tracks)
        continue = !new_tracks.count.zero? && (new_tracks.count % TRACK_LIMIT).zero?
      end

      tracks
    end

    private

    def format_playlist_name
      playlist.name.gsub(/\W+/, '_')
    end

    def file_path(_playlist)
      "#{APP_ROOT}/tmp/playlists/#{Time.now.strftime('%C%m%d')}_#{format_playlist_name}.csv"
    end
  end
end
