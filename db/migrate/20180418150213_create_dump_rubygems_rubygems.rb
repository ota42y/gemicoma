class CreateDumpRubygemsRubygems < ActiveRecord::Migration[5.2]
  def change
    create_table :dump_rubygems_rubygems do |t|
      t.string :name, null: false, index: true
      t.string :slug

      t.timestamps
    end
  end
end
