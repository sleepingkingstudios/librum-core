# frozen_string_literal: true

module Librum::Core::View::Components
  # Renders a radio component with label.
  class FormRadioButton < ViewComponent::Base
    include Librum::Core::View::Options
    include Librum::Core::View::ClassName
    include Librum::Core::View::FormErrors

    # @param name [String] the scoped name of the form input.
    # @param options [Hash] additional options for the input.
    #
    # @option options checked [Boolean] if true, the radio button renders as
    #   checked.
    # @option options disabled [Boolean] if true, renders the input as disabled.
    # @option options error_key [String] the key used to identify matching
    #   errors. Defaults to the input name.
    # @option options errors [Stannum::Errors, Array<String>] the form errors to
    #   apply.
    # @option options id [String] a unique identifier for the radio button.
    # @option options label [ViewComponent::Base, String, nil] the label to
    #   display for the radio button.
    # @option options value [String] the value for the radio button.
    def initialize(name, **options)
      super(**options)

      @name = name
    end

    option :checked?, boolean: true

    option :disabled?, boolean: true

    option :id

    option :label

    option :value

    # @return [String] the scoped name of the form input.
    attr_reader :name

    private

    def input_attributes
      hsh = {
        name:  name,
        type:  'radio',
        value: value
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
      ary = ['radio', *class_name]

      ary << 'has-text-danger' if matching_errors.any?

      ary
    end

    def render_label
      return if label == false

      return render(label) if label.is_a?(ViewComponent::Base)

      label
    end
  end
end
