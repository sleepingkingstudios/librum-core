# frozen_string_literal: true

module Spec::Support
  class User < Librum::Core::ApplicationRecord
    self.table_name = 'users'

    ### Validations
    validates :name, presence: true
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  name       :string
#  password   :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
