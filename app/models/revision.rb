# == Schema Information
#
# Table name: revisions
#
#  id              :bigint(8)        not null, primary key
#  repository_id   :integer          not null
#  repository_type :integer          not null
#  commit_hash     :string(255)      not null
#  status          :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_revisions_on_status    (status)
#  revision_commit_hash_unique  (repository_id,repository_type,commit_hash) UNIQUE
#

class Revision < ApplicationRecord
  belongs_to :repository, polymorphic: true

  has_many :revision_dependency_files, class_name: 'Revision::DependencyFile', dependent: :destroy, inverse_of: :revision

  enum status: { initialized: 0, done: 1 }
end
