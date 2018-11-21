module V1
  module Github
    class Fetcher
      class << self
        # @param [Revision] revision
        def execute(revision)
          return false unless revision.initialized?

          if revision.repository.github_ruby_gem_info
            dependency_file = ::V1::Github::GemLockFetcher.execute(revision)
            ::V1::Github::RubyVersionFetcher.execute(revision, dependency_file)
          end

          revision.downloaded!
          true
        end
      end
    end
  end
end
