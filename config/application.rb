# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Librum
  module Core
    # The test application for Librum::Core.
    class Application < Rails::Application
      # Initialize configuration defaults for originally generated Rails version.
      config.load_defaults 7.0

      config.eager_load = false
    end
  end
end
