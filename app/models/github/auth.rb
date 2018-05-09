# == Schema Information
#
# Table name: github_auths
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  uid        :integer          not null
#  nickname   :string(255)      not null
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

class Github::Auth < ApplicationRecord
  belongs_to :user, class_name: '::User', inverse_of: :github_auth

  class << self
    # @param [User] user
    def create_with_new_auth(user, auth)
      a = self.new
      a.uid = auth['uid']
      a.nickname = auth['info']['nickname']
      a.access_token = auth['credentials']['token']

      user.github_auth = a
    end
  end
end
