# frozen_string_literal: true

class Rocket
  include ActiveModel::API

  attr_accessor \
    :name,
    :slug,
    :color

  def [](key)
    send(key)
  end

  def inspect
    %(#<Rocket name="#{name}">)
  end
end
