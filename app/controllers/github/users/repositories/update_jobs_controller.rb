class Github::Users::Repositories::UpdateJobsController < ApplicationController
  def create
    user = ::Github::User.find_by!(name: params[:user_id])
    repository = user.github_repositories.find_by!(repository: params[:repository_id])

    ::FetchMasterJob.perform_later(repository.id, true)

    redirect_to "/github/users/#{user.name}/repositories/#{repository.repository}"
  end
end
