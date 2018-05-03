class CreateRevisions < ActiveRecord::Migration[5.2]
  def change
    create_table :revisions do |t|
      t.integer :repository_id, null: false
      t.string :repository_type, null: false
      t.string :commit_hash, null: false

      t.integer :status, null: false, index: true

      t.index [:repository_id, :repository_type, :commit_hash], unique: true, name: :revision_commit_hash_unique

      t.timestamps
    end
  end
end
