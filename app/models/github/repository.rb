# == Schema Information
#
# Table name: github_repositories
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  public     :boolean          default(FALSE), not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_repositories_on_name  (name) UNIQUE
#

class Github::Repository < ApplicationRecord
end
