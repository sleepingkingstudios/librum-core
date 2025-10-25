# frozen_string_literal: true

module Librum::Core # rubocop:disable Style/Documentation
  base_controller =
    if defined?(::ApplicationController)
      # :nocov:
      ::ApplicationController
      # :nocov:
    else
      ActionController::Base
    end

  # Abstract base class for engine controllers.
  class ApplicationController < base_controller
  end
end
