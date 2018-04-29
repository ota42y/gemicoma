class Github::RepositoriesController < ApplicationController
  def create
    # TODO: check github user and repository access right
    user = ::Github::User.find_or_create_by!(name: params[:user])
    repository = user.github_repositories.find_or_initialize_by(repository: params[:repository])
    add_bundle_files(repository)
    add_commit_hash(repository)

    user.save!

    redirect_to "/github/users/#{user.name}/repositories/#{repository.repository}"
  end

  private

    def add_bundle_files(repository)
      params[:bundle_files].each do |bundle_file|
        next unless bundle_file[:file_type].to_sym == :rubygem
        b = repository.github_ruby_gemfile_info
        b ||= repository.build_github_ruby_gemfile_info
        b.filepath = bundle_file['filepath']
      end
    end

    def add_commit_hash(repository)
      revision = repository.github_revisions.find_or_initialize_by(commit_hash: params[:commit_hash])
      revision.status = :initialized
    end
end
