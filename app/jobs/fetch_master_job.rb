class FetchMasterJob < ApplicationJob
  queue_as :default

  def perform(repository_id, need_sleep)
    sleep 1 if need_sleep

    repository = Github::Repository.find_by(id: repository_id)
    return false unless repository

    # V1::Github::RepositryFetcher.execute(repository)
    true
  end
end
