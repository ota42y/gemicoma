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

ActiveRecord::Schema.define(version: 2018_04_29_045551) do

  create_table "dump_rubygems_rubygems", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_dump_rubygems_rubygems_on_name"
  end

  create_table "dump_rubygems_versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "dump_rubygems_rubygem_id", null: false
    t.string "number", null: false
    t.string "platform", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dump_rubygems_rubygem_id", "number", "platform"], name: "rubygem_id_number_platform_unique_index", unique: true
  end

  create_table "github_commits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "github_repository_id", null: false
    t.string "commit_hash", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_repository_id", "commit_hash"], name: "index_github_commits_on_github_repository_id_and_commit_hash", unique: true
    t.index ["status"], name: "index_github_commits_on_status"
  end

  create_table "github_repositories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "github_user_id", null: false
    t.string "repository", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_user_id", "repository"], name: "user_id_repository_unique", unique: true
  end

  create_table "github_revisions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "github_repository_id", null: false
    t.string "commit_hash", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_repository_id", "commit_hash"], name: "index_github_revisions_on_github_repository_id_and_commit_hash", unique: true
    t.index ["status"], name: "index_github_revisions_on_status"
  end

  create_table "github_ruby_gemfile_infos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "github_repository_id", null: false
    t.string "filepath", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_repository_id"], name: "index_github_ruby_gemfile_infos_on_github_repository_id", unique: true
  end

  create_table "github_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_github_users_on_name", unique: true
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "dump_rubygems_versions", "dump_rubygems_rubygems"
  add_foreign_key "github_commits", "github_repositories"
  add_foreign_key "github_repositories", "github_users"
  add_foreign_key "github_revisions", "github_repositories"
  add_foreign_key "github_ruby_gemfile_infos", "github_repositories"
end
