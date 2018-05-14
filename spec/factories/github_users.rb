# == Schema Information
#
# Table name: github_users
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_users_on_name  (name) UNIQUE
#

FactoryBot.define do
  factory :github_user, class: 'Github::User' do
    sequence(:name, &:to_s)
  end
end
