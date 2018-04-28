class Github::RepositoriesController < ApplicationController
  def show
    render json: []
  end

  def create
    # TODO: check github user and repository access right
    ::Github::User.find_or_create_by!(name: params[:user])

    redirect_to '/github/users/ota42y/repositories/test'
  end
end
