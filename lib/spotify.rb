# frozen_string_literal: true

require_relative 'spotify/version'
require 'spotify/configuration'
require 'spotify/user'
require 'spotify/playlist'
require 'spotify/playlist_csv'
require 'spotify/track'

module Spotify
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
