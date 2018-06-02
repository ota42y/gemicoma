class RemoveDumpTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :dump_rubygems_versions
    drop_table :dump_rubygems_rubygems
  end
end
