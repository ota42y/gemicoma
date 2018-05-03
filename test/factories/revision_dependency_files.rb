# == Schema Information
#
# Table name: revision_dependency_files
#
#  id              :bigint(8)        not null, primary key
#  revision_id     :bigint(8)        not null
#  dependency_type :integer          not null
#  source_filepath :string(255)      not null
#  body            :text(65535)      not null
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

FactoryBot.define do
  factory :revision_dependency_file, class: 'Revision::DependencyFile' do
  end
end
