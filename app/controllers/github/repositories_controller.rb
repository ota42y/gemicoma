class Github::RepositoriesController < ApplicationController
  def new
    render :new
  end

  def create
    # TODO: check github user and repository access right

    user = nil
    revision = nil
    repository = nil
    ActiveRecord::Base.transaction do
      user = ::Github::User.find_or_create_by!(name: params[:user])
      repository = user.github_repositories.find_or_initialize_by(repository: params[:repository])
      create_bundle_files(repository)
      revision = add_revision(repository)
      user.save!
    end

    ::FetchRevisionJob.perform_later(revision.id, true)

    redirect_to "/github/users/#{user.name}/repositories/#{repository.repository}"
  end

  private

    def create_bundle_files(repository)
      rubygem = params[:bundle_files][:rubygem]
      return unless rubygem

      b = repository.github_ruby_gem_info
      b ||= repository.build_github_ruby_gem_info
      b.gemfile_path = rubygem['gemfile_path']

      b.save! if b.changed?
      b
    end

    # @param [Github::Repository] repository
    def add_revision(repository)
      revision = repository.revisions.find_or_initialize_by(commit_hash: params[:commit_hash])
      revision.status = :initialized
      revision.save! if revision.changed?
      revision
    end
end
