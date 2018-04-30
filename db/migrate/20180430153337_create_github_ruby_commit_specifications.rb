class CreateGithubRubyCommitSpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :github_ruby_commit_specifications do |t|
      t.references :github_commit, null: false, index: false, foreign_key: true
      t.string :name, null: false
      t.string :version, null: false
      t.string :platform, null: false

      t.index [:github_commit_id, :name], unique: true, name: :commit_gem_unique

      t.timestamps
    end
  end
end
