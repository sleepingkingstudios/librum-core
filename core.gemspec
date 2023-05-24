# frozen_string_literal: true

require_relative 'lib/core/version'

Gem::Specification.new do |gem|
  gem.name        = 'core'
  gem.version     = Core::VERSION
  gem.summary     =
    'Librum engine defining shared functionality and core models.'

  description = <<~DESCRIPTION
    The core engine for the Librum tabletop campaign companion. Defines shared
    functionality such as base controllers and serializers, as well as the core
    models such as Publisher and GameSystem.
  DESCRIPTION
  gem.description = description.strip.gsub(/\n +/, ' ')
  gem.authors     = ['Rob "Merlin" Smith']
  gem.email       = ['merlin@sleepingkingstudios.com']
  gem.homepage    = 'http://sleepingkingstudios.com'
  gem.license     = 'GPL-3.0-only'

  gem.metadata = {
    'allowed_push_host'     => 'none',
    'bug_tracker_uri'       => 'https://github.com/sleepingkingstudios/librum-core/issues',
    'homepage_url'          => gem.homepage,
    'source_code_uri'       => 'https://github.com/sleepingkingstudios/librum-core',
    'rubygems_mfa_required' => 'true'
  }

  gem.required_ruby_version = '>= 3.0.0'
  gem.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir[
      '{app,db,lib}/**/*',
      'config/routes.rb',
      'LICENSE.md',
      'README.md'
    ]
  end

  gem.add_dependency 'cuprum', '~> 1.1'
  gem.add_dependency 'cuprum-collections'
  gem.add_dependency 'cuprum-rails'
  gem.add_dependency 'stannum'

  gem.add_dependency 'pg',     '~> 1.5'
  gem.add_dependency 'rails',  '~> 7.0.4'
end
