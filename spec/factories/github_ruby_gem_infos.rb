# == Schema Information
#
# Table name: github_ruby_gem_infos
#
#  id                   :bigint(8)        not null, primary key
#  github_repository_id :bigint(8)        not null
#  gemfile_path         :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_github_ruby_gem_infos_on_github_repository_id  (github_repository_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_repository_id => github_repositories.id)
#

FactoryBot.define do
  factory :github_ruby_gem_info, class: 'Github::Ruby::GemInfo' do
    gemfile_path './'
  end
end
