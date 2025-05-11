# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  name       :string
#  password   :string
#  role       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < Librum::Core::ApplicationRecord
  self.table_name = 'users'

  ### Validations
  validates :name, presence: true

  def admin?
    role == 'admin'
  end
end
