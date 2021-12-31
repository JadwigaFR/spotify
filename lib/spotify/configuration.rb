# frozen_string_literal: true

require 'sekrets'
require 'pry'

module Spotify
  class Configuration
    attr_reader :username, :password, :client_id, :client_secret

    def initialize
      credentials = Sekrets.settings_for('./config/credentials.yml.enc')
      @username = load_username
      @client_id = credentials['client_id']
      @client_secret = credentials['client_secret']
    end

    private

    def load_username
      YAML.load_file("#{APP_ROOT}/config/credentials.yml")['username']
    end
  end
end
