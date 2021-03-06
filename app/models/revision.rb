# == Schema Information
#
# Table name: revisions
#
#  id              :bigint(8)        not null, primary key
#  repository_id   :integer          not null
#  repository_type :string           not null
#  commit_hash     :string           not null
#  status          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_revisions_on_status    (status)
#  repository_create_at         (repository_id,repository_type,created_at)
#  revision_commit_hash_unique  (repository_id,repository_type,commit_hash) UNIQUE
#

class Revision < ApplicationRecord
  belongs_to :repository, polymorphic: true

  has_one :revision_latest, class_name: 'Revision::Latest', dependent: :destroy, inverse_of: :revision
  has_many :revision_dependency_files, class_name: 'Revision::DependencyFile', dependent: :destroy, inverse_of: :revision

  enum status: { initialized: 0, downloaded: 1, done: 2 }

  def update_revision
    repository.update_revision(self)
  end
end
