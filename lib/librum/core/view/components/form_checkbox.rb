# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a checkbox component with label.
  class FormCheckbox < ViewComponent::Base
    include Librum::Core::View::Options
    include Librum::Core::View::ClassName
    include Librum::Core::View::FormErrors

    # @param id [String] a unique identifier for the input.
    # @param checked [Boolean] if true, the checkbox renders as checked.
    # @param label [ViewComponent::Base, String, nil] the label to display for
    #   the checkbox.
    # @param name [String] the scoped name of the form input.
    # @param options [Hash] additional options for the input.
    #
    # @option options disabled [Boolean] if true, renders the input as disabled.
    # @option options error_key [String] the key used to identify matching
    #   errors. Defaults to the input name.
    # @option options errors [Stannum::Errors, Array<String>] the form errors to
    #   apply.
    def initialize(
      name,
      checked: false,
      id:      nil,
      label:   nil,
      **options
    )
      super(**options)

      @name    = name
      @checked = checked
      @id      = id
      @label   = label
    end

    option :disabled?, boolean: true

    # @return [String] a unique identifier for the input.
    attr_reader :id

    # @return [ViewComponent::Base, String, nil] the label to display for the
    #   checkbox.
    attr_reader :label

    # @return [String] the scoped name of the form input.
    attr_reader :name

    # @return [Boolean] if true, the checkbox renders as checked.
    def checked?
      !!@checked
    end

    private

    def input_attributes
      hsh = {
        name:  name,
        type:  'checkbox',
        value: '1'
      }

      hsh[:checked]  = true if checked?
      hsh[:disabled] = true if disabled?
      hsh[:id]       = id   if id.present?

      hsh
    end

    def label_attributes
      hsh = {
        class: label_class_names,
        name:  name
      }

      hsh[:disabled] = true if disabled?
      hsh[:for]      = id   if id.present?

      hsh
    end

    def label_class_names
      ary = ['checkbox', *class_name]

      ary << 'has-text-danger' if matching_errors.any?

      ary
    end

    def render_hidden_input
      tag.input(autocomplete: 'off', name: name, type: 'hidden', value: '0')
    end

    def render_label
      return if label == false

      return render(label) if label.is_a?(ViewComponent::Base)

      label
    end
  end
end
