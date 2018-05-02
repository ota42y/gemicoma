class Github::Users::RepositoriesController < ApplicationController
  def show
    user = ::Github::User.find_by!(name: params[:user_id])
    @repository = user.github_repositories.find_by!(repository: params[:id])

    # @type [Revision] @revision
    @revision = @repository.revisions.first

    lock = V1::Dependency::GemLock.new(nil, @revision.revision_ruby_specifications)
    @dependency_graph = ::V1::DependencyGraph.new(lock)

    render :show
  end
end
