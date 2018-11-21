# == Schema Information
#
# Table name: revision_ruby_versions
#
#  id                          :bigint(8)        not null, primary key
#  revision_dependency_file_id :bigint(8)        not null
#  version                     :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_revision_ruby_versions_on_revision_dependency_file_id  (revision_dependency_file_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (revision_dependency_file_id => revision_dependency_files.id)
#

class Revision::Ruby::Version < ApplicationRecord
  belongs_to :revision_dependency_file, class_name: 'Revision::DependencyFile', inverse_of: :revision_ruby_specifications

  validates :version, format: { with: /\A\d+\.\d+\.\d+\Z/ }
end
