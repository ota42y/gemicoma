# == Schema Information
#
# Table name: github_repository_ruby_gems
#
#  id           :bigint(8)        not null, primary key
#  gemfile_path :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Github::Repository::RubyGem < ApplicationRecord
end
