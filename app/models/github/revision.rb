# == Schema Information
#
# Table name: github_revisions
#
#  id                   :bigint(8)        not null, primary key
#  github_repository_id :bigint(8)        not null
#  commit_hash          :string(255)      not null
#  status               :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_github_revisions_on_github_repository_id_and_commit_hash  (github_repository_id,commit_hash) UNIQUE
#  index_github_revisions_on_status                                (status)
#
# Foreign Keys
#
#  fk_rails_...  (github_repository_id => github_repositories.id)
#

class Github::Revision < ApplicationRecord
  belongs_to :github_repository, class_name: 'Github::Repository', inverse_of: :github_revisions

  enum status: { initialized: 0 }
end
