class Github::Users::RepositoriesController < ApplicationController
  def show
    user = ::Github::User.find_by!(name: params[:user_id])
    user.github_repositories.find_by!(repository: params[:id])

    render :show
  end
end
