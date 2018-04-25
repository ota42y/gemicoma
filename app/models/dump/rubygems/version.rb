# == Schema Information
#
# Table name: dump_rubygems_versions
#
#  id                       :bigint(8)        not null, primary key
#  dump_rubygems_rubygem_id :bigint(8)        not null
#  number                   :string(255)      not null
#  platform                 :string(255)      not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  rubygem_id_number_platform_unique_index  (dump_rubygems_rubygem_id,number,platform) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (dump_rubygems_rubygem_id => dump_rubygems_rubygems.id)
#

class Dump::Rubygems::Version < ApplicationRecord
  belongs_to :dump_rubygems_rubygem, class_name: 'Dump::Rubygems::Rubygem', inverse_of: :dump_rubygems_versions
end
