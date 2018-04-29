class CreateGithubRubyGemInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :github_ruby_gem_infos do |t|
      t.references :github_repository, null: false, foreign_key: true, index: { unique: true }

      t.string :gemfile_path, null: false

      t.timestamps
    end
  end
end
