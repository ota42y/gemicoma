class Github::RepositoriesController < ApplicationController
  def show
    render json: []
  end

  def create
    # TODO: check github user and repository access right
    user = ::Github::User.find_or_create_by!(name: params[:user])
    user.github_user_repositories.find_or_create_by!(repository: params[:repository])

    redirect_to '/github/users/ota42y/repositories/test'
  end
end
