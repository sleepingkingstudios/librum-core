# frozen_string_literal: true

require 'cuprum/rails/resource'

require 'librum/components/resource'

module Librum::Core
  # Abstract resource class for defining Librum controllers.
  #
  # This class may be extended by Librum engines to add additional properties or
  # functionality.
  class Resource < Cuprum::Rails::Resource
    include Librum::Components::Resource
  end
end
