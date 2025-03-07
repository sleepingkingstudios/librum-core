# frozen_string_literal: true

require 'cuprum/rails/controller'

module Librum::Core
  # Abstract base class for View controllers.
  class ViewController < Librum::Core::ApplicationController
    include Cuprum::Rails::Controller

    def self.repository
      @repository ||= Cuprum::Rails::Records::Repository.new
    end

    default_format :html

    responder :html, Librum::Core::Responders::Html::ViewResponder

    layout 'page'
  end
end
