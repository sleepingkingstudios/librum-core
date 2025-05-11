# frozen_string_literal: true

require 'support/models/user'

FactoryBot.define do
  factory :user, class: 'User' do
    transient do
      sequence(:user_index) { |index| index }
    end

    name     { "User #{user_index}" }
    slug     { "user-#{user_index}" }
    password { '12345' }
    role     { 'user' }

    trait :admin do
      # :nocov:
      role { 'admin' }
      # :nocov:
    end
  end
end
