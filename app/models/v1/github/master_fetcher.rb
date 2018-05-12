module V1
  module Github
    class MasterFetcher
      MASTER_BRANCH = 'master'.freeze

      class << self
        # @param [Repository] repository
        def execute(repository)
          commit_hash = ::V1::GithubRepository.branch_commit_hash(repository.github_path, MASTER_BRANCH)

          revision = repository.revisions.find_or_initialize_by(commit_hash: commit_hash)
          return nil if revision.persisted?

          revision.status = :initialized
          revision.save!

          revision
        end
      end
    end
  end
end
