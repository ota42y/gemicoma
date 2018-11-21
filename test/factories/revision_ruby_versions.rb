# == Schema Information
#
# Table name: revision_ruby_versions
#
#  id                          :bigint(8)        not null, primary key
#  revision_dependency_file_id :bigint(8)        not null
#  version                     :string           not null
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

FactoryBot.define do
  factory :revision_ruby_version, class: 'Revision::Ruby::Version' do
    revision_dependency_file { 'MyString' }
    version { 'MyString' }
  end
end
