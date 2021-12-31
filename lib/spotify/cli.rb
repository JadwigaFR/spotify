# frozen_string_literal: true

require 'thor'
require 'spotify'
require 'io/console'

module Spotify
  class CLI < Thor
    desc 'login', 'Login to Spotify account'
    def login
      puts 'Welcome to the Spotify playlist CLI'
      user = Spotify::User.new

      if user
        puts "You're logged in as #{user.name}."
        puts 'Do you still want to login? (yes/no)'
        user_input = gets.chomp
        recursive_log_in if user_input.eql?('yes')
      end
    rescue Error => e
      puts "Oooops! Something went wrong with error: #{e.message}"
      puts 'Try to debug yourself or send the error message + screenshot of console to your favorite developer'
    end

    private

    def recursive_log_in
      username, password = get_log_credentials
      user = Spotify::User.find(username: username, password: password)
      Spotify::User.login(user: user)
    rescue Spotify::User::Error
      puts 'Wrong credentials!'
      recursive_log_in
    end

    def get_log_credentials
      puts 'Please provide your account name'
      puts '>> '
      username = gets.chomp
      puts "What's your password"
      puts '>> '
      password = $stdin.noecho(&:gets)

      [username, password]
    end
  end
end
