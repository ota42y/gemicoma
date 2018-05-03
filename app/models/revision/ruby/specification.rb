# == Schema Information
#
# Table name: revision_ruby_specifications
#
#  id                          :bigint(8)        not null, primary key
#  revision_dependency_file_id :bigint(8)        not null
#  name                        :string(255)      not null
#  version                     :string(255)      not null
#  platform                    :string(255)      not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  dependency_file_name_unique  (revision_dependency_file_id,name) UNIQUE
#

class Revision::Ruby::Specification < ApplicationRecord
  belongs_to :revision_dependency_file, class_name: 'Revision::DependencyFile', inverse_of: :revision_ruby_specifications
end
