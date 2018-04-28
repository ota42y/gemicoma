# == Schema Information
#
# Table name: github_bundle_files
#
#  id                   :bigint(8)        not null, primary key
#  github_repository_id :bigint(8)        not null
#  file_type            :integer          not null
#  filepath             :string(255)      not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  repository_file_type_unique  (github_repository_id,file_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_repository_id => github_repositories.id)
#

FactoryBot.define do
  factory :github_bundle_file, class: 'Github::BundleFile' do
  end
end
