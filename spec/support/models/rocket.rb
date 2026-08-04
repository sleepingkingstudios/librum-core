# frozen_string_literal: true

class Rocket
  include ActiveModel::API

  attr_accessor \
    :name,
    :slug,
    :color
end
