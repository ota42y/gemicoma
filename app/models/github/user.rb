# == Schema Information
#
# Table name: github_users
#
#  id         :bigint(8)        not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_github_users_on_name  (name) UNIQUE
#

class Github::User < ApplicationRecord
  has_many :github_repositories, class_name: 'Github::Repository',
                                 dependent: :destroy,
                                 foreign_key: :github_user_id,
                                 inverse_of: :github_user

  class << self
    def dump
      Github::User.includes(github_repositories: :github_ruby_gem_info).order(:id).map do |u|
        repositories = u.github_repositories.sort_by(&:id).map do |r|
          {
              repository: r.repository, branch: r.branch,
              github_ruby_gem_info: {
                  gemfile_path: r.github_ruby_gem_info.gemfile_path,
                  ruby_version_path: r.github_ruby_gem_info.ruby_version_path,
              }
          }
        end
        {name: u.name, repositories: repositories}
      end
    end

    def restore(data)
      data.each do |u|
        user = Github::User.find_or_create_by!(name: u[:name])

        u[:repositories].each do |r|
          repo = Github::Repository.find_or_initialize_by(github_user: user, repository: r[:repository], branch: r[:branch])
          repo.save!

          i = r[:github_ruby_gem_info]
          repo.update_ruby_gem_info!(gemfile_path: i[:gemfile_path], ruby_version_path: i[:ruby_version_path])
        end
      end
    end
  end
end
