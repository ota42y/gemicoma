# == Schema Information
#
# Table name: revision_ruby_specifications
#
#  id                          :bigint(8)        not null, primary key
#  revision_dependency_file_id :bigint(8)        not null
#  name                        :string           not null
#  version                     :string           not null
#  platform                    :string           not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  dependency_file_name_unique  (revision_dependency_file_id,name) UNIQUE
#

FactoryBot.define do
  factory :revision_ruby_specification, class: 'Revision::Ruby::Specification' do
    revision_dependency_file
  end
end
