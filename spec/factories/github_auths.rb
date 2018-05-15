# == Schema Information
#
# Table name: github_auths
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  uid        :integer          not null
#  nickname   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_auths_on_uid      (uid) UNIQUE
#  index_github_auths_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :github_auth, class: 'Github::Auth' do
    sequence(:uid) { |n| n + 42 }
    sequence(:nickname, &:to_s)
  end
end
