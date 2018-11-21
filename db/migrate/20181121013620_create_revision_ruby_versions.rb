class CreateRevisionRubyVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :revision_ruby_versions do |t|
      t.references :revision_dependency_file, null: false, foreign_key: true, index: { unique: true }
      t.string :version, null: false

      t.timestamps
    end
  end
end
