# == Schema Information
#
# Table name: dump_rubygems_rubygems
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_dump_rubygems_rubygems_on_name  (name)
#

class Dump::Rubygems::Rubygem < ApplicationRecord
  has_many :dump_rubygems_versions,
           class_name: 'Dump::Rubygems::Version',
           inverse_of: :dump_rubygems_rubygem,
           foreign_key: :dump_rubygems_rubygem_id,
           dependent: :destroy
end
