class CreateRevisionDependencyFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :revision_dependency_files do |t|
      t.references :revision, null: false, foreign_key: true

      t.integer :dependency_type, null: false
      t.string :source_filepath, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
