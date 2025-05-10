# frozen_string_literal: true

require 'cuprum/rails/resource'
require 'rspec/sleeping_king_studios/deferred/provider'

require 'support/examples/commands'

module Spec::Support::Examples::Commands
  module UsersExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    # Sample data for User objects.
    USERS_FIXTURES = [
      {
        'id'       => '0196b857-8f4b-7904-b4db-5c6b74213a99',
        'name'     => 'Alan Bradley',
        'slug'     => 'alan-bradley',
        'role'     => 'user',
        'password' => 'tronlives'
      }.freeze,
      {
        'id'       => '0196b858-6ba3-77f7-8194-e57ebeb5e615',
        'name'     => 'Kevin Flynn',
        'slug'     => 'kevin-flynn',
        'role'     => 'user',
        'password' => 'theperfectsystem'
      }.freeze,
      {
        'id'       => '0196b883-000d-72b8-a6c3-2b86c784a634',
        'name'     => 'Walter Gibbs',
        'slug'     => 'walter-gibbs',
        'role'     => 'user',
        'password' => 'wontthatbegrand'
      }.freeze,
      {
        'id'       => '0196b859-039b-775f-be6b-e5686574ef8c',
        'name'     => 'Ed Dillinger',
        'slug'     => 'ed-dillinger',
        'role'     => 'admin',
        'password' => 'mastercontrol'
      }.freeze
    ].freeze
  end
end
