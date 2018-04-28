# == Schema Information
#
# Table name: github_user_repositories
#
#  id             :bigint(8)        not null, primary key
#  github_user_id :bigint(8)        not null
#  repository     :string(255)      not null
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

class Github::User::Repository < ApplicationRecord
  belongs_to :github_user, class_name: 'Github::User', inverse_of: :github_user_repositories
end
