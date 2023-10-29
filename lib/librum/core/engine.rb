# frozen_string_literal: true

module Librum
  module Core
    # Rails engine for Librum::Core.
    class Engine < ::Rails::Engine
      isolate_namespace Librum::Core

      initializer 'librum_core.assets.precompile' do |app|
        app.config.assets.precompile += %w[librum_core_manifest.js]
      end
    end
  end
end
