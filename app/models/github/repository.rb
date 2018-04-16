# == Schema Information
#
# Table name: github_repositories
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      not null
#  public     :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_repositories_on_name  (name) UNIQUE
#

class Github::Repository < ApplicationRecord
end
