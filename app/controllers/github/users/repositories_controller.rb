class Github::Users::RepositoriesController < ApplicationController
  def show
    user = ::Github::User.find_by!(name: params[:user_id])
    @repository = user.github_repositories.find_by!(repository: params[:id])

    # @type [Github::Commit] commit
    @commit = @repository.github_commits.first

    lock = V1::Dependency::GemLock.new(nil, @commit.github_ruby_commit_specifications)
    @dependency_graph = ::V1::DependencyGraph.new(lock)

    render :show
  end
end
