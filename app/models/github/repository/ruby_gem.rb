# == Schema Information
#
# Table name: github_repository_ruby_gems
#
#  created_at   :datetime         not null
#  gemfile_path :string(255)      not null
#  id           :bigint(8)        not null, primary key
#  updated_at   :datetime         not null
#


class Github::Repository::RubyGem < ApplicationRecord
end
