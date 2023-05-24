# frozen_string_literal: true

module Core
  # Rails engine for Librum::Core.
  class Engine < ::Rails::Engine
    isolate_namespace Core
  end
end
