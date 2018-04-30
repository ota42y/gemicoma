class CheckNewCommitJob < ApplicationJob
  queue_as :default

  def perform(commit_id, need_sleep)
    sleep 1 if need_sleep

    commit = ::Github::Commit.find_by(id: commit_id)
    return false unless commit

    V1::GithubCommitAnalyzer.execute(commit)
  end
end
