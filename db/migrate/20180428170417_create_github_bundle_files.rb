class CreateGithubBundleFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :github_bundle_files do |t|
      t.references :github_repository, null: false, foreign_key: true, index: false

      t.integer :file_type, null: false
      t.string :filepath, null: false

      t.index [:github_repository_id, :file_type], unique: true, name: :repository_file_type_unique

      t.timestamps
    end
  end
end
