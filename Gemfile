# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in librum-core.gemspec.
gemspec

### Assets
gem 'importmap-rails' # Use JavaScript with ESM import maps
gem 'sprockets-rails' # The original asset pipeline for Rails

### Commands
gem 'cuprum', '~> 1.3'
gem 'cuprum-collections',
  '>= 0.5.0.alpha',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum-collections'
gem 'cuprum-rails',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/cuprum-rails'
gem 'stannum',
  branch: 'main',
  git:    'https://github.com/sleepingkingstudios/stannum'

gem 'sleeping_king_studios-tools', '~> 1.2'

group :development, :test do
  gem 'annotaterb', '~> 4.14'

  gem 'byebug'

  # See https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md
  gem 'factory_bot_rails', '~> 6.4'

  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '~> 7.1'
  gem 'rspec-sleeping_king_studios', '~> 2.8', '>= 2.8.1'
  gem 'rubocop', '~> 1.75'
  gem 'rubocop-factory_bot', '~> 2.27'
  gem 'rubocop-rails', '~> 2.31' # https://docs.rubocop.org/rubocop-rails/
  gem 'rubocop-rake', '~> 0.7'
  gem 'rubocop-rspec', '~> 3.6' # https://docs.rubocop.org/rubocop-rspec/
  gem 'rubocop-rspec_rails', '~> 2.31'

  gem 'simplecov', '~> 0.21'
end

group :development do
  gem 'sleeping_king_studios-tasks', '~> 0.4', '>= 0.4.1'
end
