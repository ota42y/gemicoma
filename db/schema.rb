# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_12_085226) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admins_on_user_id", unique: true
  end

  create_table "github_auths", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "uid", null: false
    t.string "nickname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_github_auths_on_uid", unique: true
    t.index ["user_id"], name: "index_github_auths_on_user_id", unique: true
  end

  create_table "github_repositories", force: :cascade do |t|
    t.bigint "github_user_id", null: false
    t.string "repository", null: false
    t.string "branch", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_user_id", "repository"], name: "user_id_repository_unique", unique: true
  end

  create_table "github_ruby_gem_infos", force: :cascade do |t|
    t.bigint "github_repository_id", null: false
    t.string "gemfile_path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_repository_id"], name: "index_github_ruby_gem_infos_on_github_repository_id", unique: true
  end

  create_table "github_users", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_github_users_on_name", unique: true
  end

  create_table "revision_dependency_files", force: :cascade do |t|
    t.bigint "revision_id", null: false
    t.integer "dependency_type", null: false
    t.string "source_filepath", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["revision_id"], name: "index_revision_dependency_files_on_revision_id"
  end

  create_table "revision_latests", force: :cascade do |t|
    t.integer "repository_id", null: false
    t.string "repository_type", null: false
    t.bigint "revision_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "repository_type"], name: "repository_unique", unique: true
    t.index ["revision_id"], name: "index_revision_latests_on_revision_id"
  end

  create_table "revision_ruby_specifications", force: :cascade do |t|
    t.bigint "revision_dependency_file_id", null: false
    t.string "name", null: false
    t.string "version", null: false
    t.string "platform", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["revision_dependency_file_id", "name"], name: "dependency_file_name_unique", unique: true
  end

  create_table "revisions", force: :cascade do |t|
    t.integer "repository_id", null: false
    t.string "repository_type", null: false
    t.string "commit_hash", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "repository_type", "commit_hash"], name: "revision_commit_hash_unique", unique: true
    t.index ["repository_id", "repository_type", "created_at"], name: "repository_create_at"
    t.index ["status"], name: "index_revisions_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admins", "users"
  add_foreign_key "github_auths", "users"
  add_foreign_key "github_repositories", "github_users"
  add_foreign_key "github_ruby_gem_infos", "github_repositories"
  add_foreign_key "revision_dependency_files", "revisions"
  add_foreign_key "revision_latests", "revisions"
end
