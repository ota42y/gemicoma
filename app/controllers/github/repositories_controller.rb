class Github::RepositoriesController < ApplicationController
  def show
    render json: []
  end

  def create
    # TODO: check github user and repository access right
    user = ::Github::User.find_or_create_by!(name: params[:user])
    repository = user.github_repositories.find_or_initialize_by(repository: params[:repository])

    params[:bundle_files].each do |bundle_file|
      b = repository.github_bundle_files.find { |bundle| bundle.file_type == bundle_file[:file_type] }
      b ||= repository.github_bundle_files.build(file_type: bundle_file[:file_type])
      b.filepath = bundle_file['filepath']
    end

    user.save!

    redirect_to "/github/users/#{user.name}/repositories/#{repository.repository}"
  end
end
