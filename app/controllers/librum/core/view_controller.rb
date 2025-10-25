# frozen_string_literal: true

require 'cuprum/rails/controller'

module Librum::Core
  # Abstract base class for View controllers.
  class ViewController < Librum::Core::ApplicationController
    default_format :html

    responder :html, Librum::Core::Responders::Html::ViewResponder

    layout 'page'
  end
end
