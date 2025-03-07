# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :slug
      t.string :password

      t.timestamps
    end
  end
end
