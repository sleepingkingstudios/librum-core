# frozen_string_literal: true

require 'support/user'

FactoryBot.define do
  factory :user, class: 'Spec::Support::User' do
    transient do
      sequence(:user_index) { |index| index }
    end

    name     { "User #{user_index}" }
    slug     { "user-#{user_index}" }
    password { '12345' }
  end
end
