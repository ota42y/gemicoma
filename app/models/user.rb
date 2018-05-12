# == Schema Information
#
# Table name: users
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  class << self
    def find_with_omniauth(provider:, uid:)
      return ::Github::Auth.find_by(uid: uid)&.user if provider == 'github'
      nil
    end

    def create_with_omniauth(auth)
      provider = auth['provider']

      user = User.new
      ActiveRecord::Base.transaction do
        ::Github::Auth.create_with_new_auth(user, auth) if provider == 'github'

        user.save!
      end

      user
    end
  end

  has_one :admin, dependent: :destroy
  has_one :github_auth, class_name: 'Github::Auth', dependent: :destroy, inverse_of: :user
end
