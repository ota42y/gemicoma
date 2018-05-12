# == Schema Information
#
# Table name: admins
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_admins_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Admin < ApplicationRecord
  belongs_to :user
end
