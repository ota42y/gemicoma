# == Schema Information
#
# Table name: github_ruby_commit_specifications
#
#  id               :bigint(8)        not null, primary key
#  github_commit_id :bigint(8)        not null
#  name             :string(255)      not null
#  version          :string(255)      not null
#  platform         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  commit_gem_unique  (github_commit_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_commit_id => github_commits.id)
#

class Github::Ruby::CommitSpecification < ApplicationRecord
  belongs_to :github_commit, class_name: 'Github::Commit', inverse_of: :github_ruby_commit_specifications
end
