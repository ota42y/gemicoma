class CreateRevisionRubySpecifications < ActiveRecord::Migration[5.2]
  def change
    create_table :revision_ruby_specifications do |t|
      t.references :revision, null: false

      t.string :name, null: false
      t.string :version, null: false
      t.string :platform, null: false

      t.index [:revision_id, :name], unique: true, name: :revision_name_unique

      t.timestamps
    end
  end
end
