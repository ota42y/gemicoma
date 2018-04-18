# == Schema Information
#
# Table name: github_repository_bundle_files
#
#  id         :bigint(8)        not null, primary key
#  kind       :integer          not null
#  filepath   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Github::Repository::BundleFile < ApplicationRecord
end
