# frozen_string_literal: true

require 'librum/core/view/layouts/page'
require 'librum/core/view/layouts/page/alert'

module Librum::Core::View::Layouts
  # Renders the page alerts.
  class Page::Alerts < ViewComponent::Base
    # @param alerts [Hash{String=>String}] the alerts to display.
    def initialize(alerts:)
      super()

      @alerts = parse_alerts(alerts)
    end

    # @return [Array<Hash{String=>String}>] the configured alert objects.
    attr_reader :alerts

    private

    def parse_alert(alert)
      return alert.stringify_keys if alert.is_a?(Hash)

      { 'message' => alert }
    end

    def parse_alerts(alerts)
      alerts.map { |(key, value)| parse_alert(value).merge('color' => key) }
    end
  end
end
