class Github::Users::RepositoriesController < ApplicationController
  def show
    user = ::Github::User.find_by!(name: params[:user_id])
    @repository = user.github_repositories.find_by!(repository: params[:id])

    # @type [Revision] @revision
    @revision = @repository.revisions.first
    # @type [Revision::DependencyFile] dependency
    dependency = @revision.revision_dependency_files.first

    @dependency_graph = ::V1::DependencyGraph.new(dependency)

    render :show
  end
end
