class CreateGithubRepositoryBundleFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :github_repository_bundle_files do |t|
      t.integer :kind, null: false
      t.string :filepath, null: false

      t.timestamps
    end
  end
end
