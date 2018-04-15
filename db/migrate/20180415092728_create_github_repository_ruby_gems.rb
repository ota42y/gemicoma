class CreateGithubRepositoryRubyGems < ActiveRecord::Migration[5.2]
  def change
    create_table :github_repository_ruby_gems do |t|
      t.string :gemfile_path, null: false

      t.timestamps
    end
  end
end
