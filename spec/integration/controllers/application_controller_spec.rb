# frozen_string_literal: true

require 'open3'

require 'rails_helper'

RSpec.describe Librum::Core::ApplicationController do
  let(:fixture_path) do
    'spec/integration/controllers/application_controller_spec.fixture.rb'
  end
  let(:command) do
    "COVERAGE=false bundle exec rspec #{fixture_path} --format=json"
  end

  define_method :run_command do
    json = nil

    Open3.popen3(command) do |_, stdout|
      raw  = stdout.read
      json = JSON.parse(raw)
    end

    json
  end

  it { expect(run_command['summary_line']).to be == '1 example, 0 failures' }
end
