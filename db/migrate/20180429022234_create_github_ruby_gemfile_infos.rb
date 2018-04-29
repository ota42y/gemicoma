class CreateGithubRubyGemfileInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :github_ruby_gemfile_infos do |t|
      t.references :github_repository, null: false, foreign_key: true, index: { unique: true }

      t.string :filepath, null: false

      t.timestamps
    end
  end
end
