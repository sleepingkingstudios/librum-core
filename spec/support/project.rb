# frozen_string_literal: true

require 'support/user'

module Spec::Support
  class Project < Librum::Core::ApplicationRecord
    self.table_name = 'projects'

    ### Associations
    belongs_to :user, class_name: 'Spec::Support::User'
  end
end
