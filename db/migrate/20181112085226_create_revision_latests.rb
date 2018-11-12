class CreateRevisionLatests < ActiveRecord::Migration[5.2]
  def change
    create_table :revision_latests do |t|
      t.integer :repository_id, null: false
      t.string :repository_type, null: false

      t.references :revision, null: false, foreign_key: true

      t.index [:repository_id, :repository_type], unique: true, name: :repository_unique

      t.timestamps
    end
  end
end
