class Github::Users::RepositoriesController < ApplicationController
  def show
    user = ::Github::User.find_by!(name: params[:user_id])
    @repository = user.github_repositories.find_by!(repository: params[:id])

    # @type [Revision] @revision
    @revision = @repository.revisions.order(created_at: :desc).first

    if @revision&.done?
      # @type [Revision::DependencyFile] dependency
      dependency = @revision.revision_dependency_files.first

      rubygem_specification = V1::RubygemsSpecification.default_rubygem
      @dependency_graph = ::V1::DependencyGraph.new(dependency, rubygem_specification)
    end

    render :show
  end
end
