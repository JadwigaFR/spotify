# frozen_string_literal: true

require 'sekrets'
require 'pry'

module Spotify
  class Configuration
    attr_writer :username, :password

    def self.username
      credentials = Sekrets.settings_for('./config/credentials.yml.enc')
      @username = credentials["username"]
      @password =  credentials["password"]
    end
  end
end
