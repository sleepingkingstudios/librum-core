# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_22_134431) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "authentication_credentials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type", null: false
    t.boolean "active", default: true, null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "expires_at", precision: nil, null: false
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "type"], name: "index_authentication_credentials_on_user_id_and_type"
  end

  create_table "authentication_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "role", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_authentication_users_on_email", unique: true
    t.index ["slug"], name: "index_authentication_users_on_slug", unique: true
    t.index ["username"], name: "index_authentication_users_on_username", unique: true
  end

  create_table "dnd5e_conditions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.boolean "stub", default: false, null: false
    t.jsonb "source_metadata", default: {}, null: false
    t.string "short_description", default: "", null: false
    t.text "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "source_id"
    t.index ["slug"], name: "index_dnd5e_conditions_on_slug"
    t.index ["source_id", "slug"], name: "index_dnd5e_conditions_on_source_id_and_slug", unique: true
    t.index ["source_id"], name: "index_dnd5e_conditions_on_source_id"
  end

  create_table "game_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "publisher_id"
    t.index ["name"], name: "index_game_settings_on_name", unique: true
    t.index ["publisher_id"], name: "index_game_settings_on_publisher_id"
    t.index ["slug"], name: "index_game_settings_on_slug", unique: true
  end

  create_table "game_systems", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "edition", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "publisher_id"
    t.index ["name", "edition"], name: "index_game_systems_on_name_and_edition", unique: true
    t.index ["publisher_id"], name: "index_game_systems_on_publisher_id"
    t.index ["slug"], name: "index_game_systems_on_slug", unique: true
  end

  create_table "generic_references", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.boolean "stub", default: false, null: false
    t.jsonb "source_metadata", default: {}, null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "source_id"
    t.index ["slug"], name: "index_generic_references_on_slug"
    t.index ["source_id", "slug"], name: "index_generic_references_on_source_id_and_slug", unique: true
    t.index ["source_id"], name: "index_generic_references_on_source_id"
  end

  create_table "publishers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.string "website", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_publishers_on_name", unique: true
    t.index ["slug"], name: "index_publishers_on_slug", unique: true
  end

  create_table "sources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type", null: false
    t.jsonb "data", default: {}, null: false
    t.string "name", default: "", null: false
    t.string "slug", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "game_system_id"
    t.uuid "publisher_id"
    t.uuid "game_setting_id"
    t.uuid "user_id"
    t.index ["game_setting_id"], name: "index_sources_on_game_setting_id"
    t.index ["game_system_id"], name: "index_sources_on_game_system_id"
    t.index ["name", "game_system_id", "publisher_id"], name: "index_sources_on_name_and_game_system_id_and_publisher_id", unique: true
    t.index ["publisher_id"], name: "index_sources_on_publisher_id"
    t.index ["slug", "game_system_id"], name: "index_sources_on_slug_and_game_system_id", unique: true
    t.index ["user_id"], name: "index_sources_on_user_id"
  end

end
