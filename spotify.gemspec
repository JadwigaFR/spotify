# frozen_string_literal: true

require_relative 'lib/spotify/version'

Gem::Specification.new do |spec|
  spec.name = 'spotify'
  spec.version = Spotify::VERSION
  spec.authors = ['Jadwiga']
  spec.email = ['jadwiga.coumert@gmail.com']

  spec.summary = 'Spotify playlists CLI'
  spec.description = 'CLI to download spotify playlists as csvs'
  spec.homepage = 'https://github.com/JadwigaFR'
  spec.required_ruby_version = '>= 2.6.6'

  spec.metadata['allowed_push_host'] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/JadwigaFR/spotify'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.2.0'
  spec.add_dependency 'rspotify', '~> 2.11', '>= 2.11.1'
  spec.add_dependency 'thor', '~> 1.1'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'sekrets', '~> 1.10'
end
