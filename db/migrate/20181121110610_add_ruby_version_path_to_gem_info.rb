class AddRubyVersionPathToGemInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :github_ruby_gem_infos, :ruby_version_path, :string
  end
end
