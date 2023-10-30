# frozen_string_literal: true

require_relative 'lib/librum/core/version'

Gem::Specification.new do |gem|
  gem.name        = 'librum-core'
  gem.version     = Librum::Core::VERSION
  gem.summary     =
    'Librum engine defining core functionality.'

  description = <<~DESCRIPTION
    The core engine for the Librum application framework. Defines shared
    functionality such as base controllers, actions, views, and serializers.
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
      '{app}/**/*',
      'config/routes.rb',
      'db/migrate/**/*',
      'lib/librum/**/*',
      'LICENSE.md',
      'README.md'
    ]
  end

  gem.add_dependency 'cuprum', '~> 1.1'
  gem.add_dependency 'cuprum-collections'
  gem.add_dependency 'cuprum-rails'
  gem.add_dependency 'stannum', '~> 0.3'

  gem.add_dependency 'annotate',        '~> 3.2'
  gem.add_dependency 'importmap-rails', '~> 1.2'
  gem.add_dependency 'pg',              '~> 1.5'
  gem.add_dependency 'rails',           '~> 7.0.4'
  gem.add_dependency 'stimulus-rails',  '~> 1.3'
  gem.add_dependency 'view_component',  '~> 3.0'

  gem.add_dependency 'diffy', '~> 3.4.2'
end
