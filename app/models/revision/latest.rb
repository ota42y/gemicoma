# == Schema Information
#
# Table name: revision_latests
#
#  id              :bigint(8)        not null, primary key
#  repository_id   :integer          not null
#  repository_type :string           not null
#  revision_id     :bigint(8)        not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_revision_latests_on_revision_id  (revision_id)
#  repository_unique                      (repository_id,repository_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (revision_id => revisions.id)
#

class Revision::Latest < ApplicationRecord
  belongs_to :repository, polymorphic: true
  belongs_to :revision

  def update_revision(revision)
    self.revision = revision
    self.save!
  end
end
