class Github::RepositoriesController < ApplicationController
  def new
    render :new
  end

  def create
    # TODO: check github user and repository access right
    user = ::Github::User.find_or_create_by!(name: params[:user])
    repository = user.github_repositories.find_or_initialize_by(repository: params[:repository])
    add_bundle_files(repository)
    commit = add_commit_hash(repository)

    user.save!

    ::CheckNewCommitJob.perform_later(commit.id, true)

    redirect_to "/github/users/#{user.name}/repositories/#{repository.repository}"
  end

  private

    def add_bundle_files(repository)
      rubygem = params[:bundle_files][:rubygem]
      return unless rubygem

      b = repository.github_ruby_gemfile_info
      b ||= repository.build_github_ruby_gemfile_info
      b.filepath = rubygem['filepath']
    end

    def add_commit_hash(repository)
      commit = repository.github_commits.find_or_initialize_by(commit_hash: params[:commit_hash])
      commit.status = :initialized
      commit
    end
end
