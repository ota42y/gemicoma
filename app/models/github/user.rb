# == Schema Information
#
# Table name: github_users
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_users_on_name  (name) UNIQUE
#

class Github::User < ApplicationRecord
end
