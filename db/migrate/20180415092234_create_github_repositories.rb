class CreateGithubRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :github_repositories do |t|
      t.string :name, null: false, index: { unique: true }
      t.boolean :public, null: false, default: false

      t.timestamps
    end
  end
end
