# frozen_string_literal: true

require 'spotify'

RSpec.describe Spotify do
  it 'has a version number' do
    expect(Spotify::VERSION).not_to be nil
  end
end
