# frozen_string_literal: true

require 'rails'
require 'action_controller'

class ApplicationController < ActionController::Base; end

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../../config/environment', __dir__)

RSpec.describe Librum::Core::ApplicationController do
  it { expect(described_class).to be < ApplicationController }
end
