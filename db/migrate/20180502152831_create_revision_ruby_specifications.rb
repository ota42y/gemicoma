class CreateRevisionRubySpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :revision_ruby_specifications do |t|
      t.references :revision_dependency_file, null: false, index: false, forekign_key: true

      t.string :name, null: false
      t.string :version, null: false
      t.string :platform, null: false

      t.index [:revision_dependency_file_id, :name], unique: true, name: :dependency_file_name_unique

      t.timestamps
    end
  end
end
