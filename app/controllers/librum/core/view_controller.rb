# frozen_string_literal: true

require 'cuprum/rails/controller'

require 'librum/core/responders/html/view_responder'
require 'librum/core/view/layouts/page'

module Librum::Core
  # Abstract base class for View controllers.
  class ViewController < Librum::Core::ApplicationController
    include Cuprum::Rails::Controller

    def self.repository
      @repository ||= Cuprum::Rails::Repository.new
    end

    default_format :html

    responder :html, Librum::Core::Responders::Html::ViewResponder

    layout 'page'
  end
end
