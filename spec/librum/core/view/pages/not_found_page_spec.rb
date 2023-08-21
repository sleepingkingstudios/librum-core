# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Librum::Core::View::Pages::NotFoundPage, type: :component do
  subject(:page) { described_class.new(result) }

  let(:result) { Cuprum::Result.new }

  describe '#call' do
    let(:rendered) { render_inline(page) }
    let(:snapshot) do
      <<~HTML
        <div class="content">
          <h1>Not Found</h1>

          <p>
            This is not a place of honor.

            <br>

            No highly esteemed deed is commemorated here.

            <br>

            Nothing valued is here.
          </p>

          <p>
            What is here was dangerous and repulsive to us.

            <br>

            This message is a warning about danger.

            <br>

            The danger is still present, in your time, as it was in ours.
          </p>

          <p>
            This place is best shunned and left uninhabited.
          </p>
        </div>
      HTML
    end

    it 'should match the snapshot' do
      expect(rendered).to match_snapshot(snapshot)
    end
  end
end
