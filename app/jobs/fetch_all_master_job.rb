class FetchAllMasterJob < ApplicationJob
  queue_as :default

  def perform
    Github::Repository.all.each do |repository|
      FetchMasterJob.perform_later(repository.id, true)
    end

    true
  end
end
