class Github::RepositoriesController < ApplicationController
  def create
    # TODO: check github user and repository access right
    user = ::Github::User.find_or_create_by!(name: params[:user])
    repository = user.github_repositories.find_or_initialize_by(repository: params[:repository])

    params[:bundle_files].each do |bundle_file|
      next unless bundle_file[:file_type].to_sym == :rubygem
      b = repository.github_ruby_gemfile_info
      b ||= repository.build_github_ruby_gemfile_info
      b.filepath = bundle_file['filepath']
    end

    user.save!

    redirect_to "/github/users/#{user.name}/repositories/#{repository.repository}"
  end
end
