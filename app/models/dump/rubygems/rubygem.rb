# == Schema Information
#
# Table name: dump_rubygems_rubygems
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      not null
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_dump_rubygems_rubygems_on_name  (name)
#

class Dump::Rubygems::Rubygem < ApplicationRecord
end
