class CreateDumpRubygemsVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :dump_rubygems_versions do |t|
      t.references :dump_rubygems_rubygem, null: false, foreign_key: true, index: false
      t.string :number, null: false
      t.string :platform, null: false

      t.index [:dump_rubygems_rubygem_id, :number, :platform],
              unique: true,
              name: :rubygem_id_number_platform_unique_index

      t.timestamps
    end
  end
end
