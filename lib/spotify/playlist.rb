# frozen_string_literal: true

module Spotify
  class Playlist
    TRACK_LIMIT = 100
    attr_reader :playlist, :path

    def initialize(user_id:, playlist_id:)
      @playlist = RSpotify::Playlist.find(user_id, playlist_id)
      @path = file_path(playlist)
    end

    def tracks
      RSpotify::Track.find(find_track_ids)
    end

    private

    def find_track_ids
      track_ids = playlist.tracks(limit: TRACK_LIMIT).map(&:id)
      continue = track_ids.count.eql?(TRACK_LIMIT)
      counter = 0

      while continue
        counter += 1
        offset = TRACK_LIMIT * counter
        track_ids.concat(playlist.tracks(limit: TRACK_LIMIT, offset: offset))
        continue = track_ids.count != TRACK_LIMIT && (track_ids.count % TRACK_LIMIT).zero?
      end

      track_ids
    end

    def format_playlist_name
      playlist.name.gsub(/\W+/, '_')
    end

    def file_path(_playlist)
      "#{APP_ROOT}/tmp/playlists/#{Time.now.strftime('%C%m%d')}_#{format_playlist_name}.csv"
    end
  end
end
