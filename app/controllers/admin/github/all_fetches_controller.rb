class Admin::Github::AllFetchesController < Admin::BaseController
  def create
    ::FetchAllMasterJob.perform_later

    redirect_to root_path
  end
end
