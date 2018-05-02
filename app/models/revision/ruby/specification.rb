# == Schema Information
#
# Table name: revision_ruby_specifications
#
#  id          :bigint(8)        not null, primary key
#  revision_id :bigint(8)        not null
#  name        :string(255)      not null
#  version     :string(255)      not null
#  platform    :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_revision_ruby_specifications_on_revision_id  (revision_id)
#  revision_name_unique                               (revision_id,name) UNIQUE
#

class Revision::Ruby::Specification < ApplicationRecord
  belongs_to :revision, inverse_of: :revision_ruby_specifications
end
