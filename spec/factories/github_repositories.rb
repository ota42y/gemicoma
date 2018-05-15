# == Schema Information
#
# Table name: github_repositories
#
#  id             :bigint(8)        not null, primary key
#  github_user_id :bigint(8)        not null
#  repository     :string           not null
#  branch         :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  user_id_repository_unique  (github_user_id,repository) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_user_id => github_users.id)
#

FactoryBot.define do
  factory :github_repository, class: 'Github::Repository' do
    github_user

    sequence(:repository, &:to_s)
    branch 'master'
  end
end
