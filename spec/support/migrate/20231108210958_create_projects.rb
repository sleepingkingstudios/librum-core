# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.text :notes

      t.timestamps
    end

    add_reference :projects, :user, type: :uuid
  end
end
