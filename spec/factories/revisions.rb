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

FactoryBot.define do
  factory :revision do
    commit_hash { SecureRandom.hex(40) }
    status { :initialized }
  end
end
