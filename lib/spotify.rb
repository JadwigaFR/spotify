# frozen_string_literal: true

require_relative 'spotify/version'
require 'spotify/configuration'
require 'spotify/user'

module Spotify
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
