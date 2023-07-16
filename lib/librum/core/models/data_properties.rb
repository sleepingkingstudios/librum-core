# frozen_string_literal: true

module Librum::Core::Models
  # Reusable component for defining properties based on a Hash column.
  module DataProperties
    # Defines reader and writer methods wrapping a data value.
    #
    # Given a property name, defines instance reader and writer methods that
    # reference the corresponding value in the object's :data Hash. If the
    # :predicate option is set to true, also defines a predicate method, which
    # checks for the presence of the value.
    #
    # @param property_name [String, Symbol] The name of the property to define.
    # @param predicate [true, false] If true, defines a predicate method.
    #
    # @example Defining A Data Property
    #   class RocketEngine < Struct.new(:data)
    #     data_property :thrust
    #   end
    #
    #   rocket = RocketEngine.new({ 'thrust' => '1_000 kN' })
    #   rocket.thrust
    #   #=> '1_000 kN'
    #   rocket.thrust = '10_000 kN'
    #   rocket.data
    #   #=> { 'thrust' => '10_000 kN' }
    #
    # @example Defining A Data Property With A Predicate
    #   class RocketPart < Struct.new(:data)
    #     data_property :manufacturer, predicate: true
    #   end
    #
    #   rocket = RocketPart.new({ 'mass' => '100 kg' })
    #   rocket.manufacturer?
    #   #=> false
    #   rocket.manufacturer = 'Probodyne'
    #   rocket.data
    #   #=> { 'mass' => '100 kg', 'manufacturer' => 'Probodyne' }
    #   rocket.manufacturer?
    #   #=> true
    def data_property(property_name, predicate: false)
      property_name = property_name.to_s

      define_reader(property_name)
      define_writer(property_name)
      define_predicate(property_name) if predicate
    end

    private

    def define_reader(property_name)
      reader_name = property_name.intern

      define_method(reader_name) { data[property_name] }
    end

    def define_predicate(property_name)
      predicate_name = :"#{property_name}?"

      define_method(predicate_name) { data[property_name].present? }
    end

    def define_writer(property_name)
      writer_name = :"#{property_name}="

      define_method(writer_name) { |value| data[property_name] = value }
    end
  end
end
