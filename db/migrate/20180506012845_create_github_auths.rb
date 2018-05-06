class CreateGithubAuths < ActiveRecord::Migration[5.2]
  def change
    create_table :github_auths do |t|
      t.references :user, null: false, index: { unique: true }, foreign_key: true
      t.integer :uid, null: false, index: { unique: true }
      t.string :nickname, null: false
      t.string :access_token, null: false

      t.timestamps
    end
  end
end
