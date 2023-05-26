# frozen_string_literal: true

require 'support/user'

FactoryBot.define do
  factory :user, class: 'Spec::Support::User' do
    id { SecureRandom.uuid }

    transient do
      sequence(:user_index) { |index| index }
    end

    username { "User #{user_index}" }
    slug     { "user-#{user_index}" }
    password { '12345' }
  end
end
