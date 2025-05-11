# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :uuid             not null, primary key
#  name       :string
#  notes      :text
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#
require_relative 'user'

class Project < Librum::Core::ApplicationRecord
  self.table_name = 'projects'

  ### Associations
  belongs_to :user, class_name: 'User'
end
