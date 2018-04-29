class CheckNewCommitJob < ApplicationJob
  queue_as :default

  def perform(commit_id, need_sleep)
    sleep 1 if need_sleep

    # TODO: update revision
  end
end
