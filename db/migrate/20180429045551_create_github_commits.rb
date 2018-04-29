class CreateGithubCommits < ActiveRecord::Migration[5.2]
  def change
    create_table :github_commits do |t|
      t.references :github_repository, null: false, foreign_key: true, index: false

      t.string :commit_hash, null: false
      t.integer :status, null: false, index: true

      t.index [:github_repository_id, :commit_hash], unique: true

      t.timestamps
    end
  end
end
