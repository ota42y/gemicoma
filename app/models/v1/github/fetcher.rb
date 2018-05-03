module V1
  module Github
    class Fetcher
      class << self
        # @param [Revision] revision
        def execute(revision)
          return false unless revision.initialized?

          ::V1::Github::GemLockFetcher.execute(revision) if revision.repository.github_ruby_gem_info

          revision.downloaded!
          true
        end
      end
    end
  end
end
