# frozen_string_literal: true

module Librum
  module Core
    # Rails engine for Librum::Core.
    class Engine < ::Rails::Engine
      isolate_namespace Librum::Core
    end
  end
end
