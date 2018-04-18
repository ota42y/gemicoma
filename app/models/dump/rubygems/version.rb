# == Schema Information
#
# Table name: dump_rubygems_versions
#
#  id                       :bigint(8)        not null, primary key
#  dump_rubygems_rubygem_id :bigint(8)        not null
#  number                   :string(255)      not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_dump_rubygems_versions_on_dump_rubygems_rubygem_id  (dump_rubygems_rubygem_id)
#
# Foreign Keys
#
#  fk_rails_...  (dump_rubygems_rubygem_id => dump_rubygems_rubygems.id)
#

class Dump::Rubygems::Version < ApplicationRecord
end
