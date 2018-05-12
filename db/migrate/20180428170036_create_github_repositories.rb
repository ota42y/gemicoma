class CreateGithubRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :github_repositories do |t|
      t.references :github_user, null: false, foreign_key: true, index: false
      t.string :repository, null: false
      t.string :branch, null: false

      t.index [:github_user_id, :repository], unique: true, name: :user_id_repository_unique

      t.timestamps
    end
  end
end
