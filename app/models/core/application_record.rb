# frozen_string_literal: true

module Core
  # Abstract base class for engine models.
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
