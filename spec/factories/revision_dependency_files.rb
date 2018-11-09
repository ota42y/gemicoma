# == Schema Information
#
# Table name: revision_dependency_files
#
#  id              :bigint(8)        not null, primary key
#  revision_id     :bigint(8)        not null
#  dependency_type :integer          not null
#  source_filepath :string           not null
#  body            :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_revision_dependency_files_on_revision_id  (revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (revision_id => revisions.id)
#

FactoryBot.define do
  factory :revision_dependency_file, class: 'Revision::DependencyFile' do
    trait :gemfile_lock do
      dependency_type { :gemfile_lock }
      source_filepath { './' }
      body { <<~GEMFILE }
        GEM
          remote: https://rubygems.org/
          specs:
            ota42y_rubygems_hands_on (0.1.2)
              ota42y_test_gem
            ota42y_test_gem (0.2.0)
         PLATFORMS
          ruby
         DEPENDENCIES
          ota42y_rubygems_hands_on (>= 0.1.2)
         BUNDLED WITH
           1.16.1

      GEMFILE
    end
  end
end
