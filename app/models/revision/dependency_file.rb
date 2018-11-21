# == Schema Information
#
# Table name: revision_dependency_files
#
#  id              :bigint(8)        not null, primary key
#  revision_id     :bigint(8)        not null
#  dependency_type :integer          not null
#  source_filepath :string           not null
#  body            :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_revision_dependency_files_on_revision_id  (revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (revision_id => revisions.id)
#

class Revision::DependencyFile < ApplicationRecord
  belongs_to :revision, inverse_of: :revision_dependency_files

  has_many :revision_ruby_specifications,
           class_name: 'Revision::Ruby::Specification',
           dependent: :destroy,
           inverse_of: :revision_dependency_file,
           foreign_key: :revision_dependency_file_id

  has_one :revision_ruby_version, class_name: 'Revision::Ruby::Version',
                                  dependent: :destroy,
                                  inverse_of: :revision_dependency_file,
                                  foreign_key: :revision_dependency_file_id

  enum dependency_type: { gemfile_lock: 1 }
end
