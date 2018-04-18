class CreateDumpRubygemsVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :dump_rubygems_versions do |t|
      t.references :dump_rubygems_rubygem, null: false, foreign_key: true
      t.string :number, null: false

      t.timestamps
    end
  end
end
