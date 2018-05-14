module V1
  module Github
    class GemLockFetcher
      class << self
        # @param [Revision] revision
        def execute(revision)
          self.new(revision).execute!
        end
      end

      # @param [Revision] revision
      def initialize(revision)
        @revision = revision
        @repository = revision.repository
      end

      def execute!
        @revision.
          revision_dependency_files.
          build(dependency_type: :gemfile_lock, source_filepath: gemfile_lock_path, body: gemfile_lock_str)
      end

      private

        def gemfile_lock_str
          @gemfile_lock_str ||= ::V1::GithubRepository.contents_by_string(@repository.github_path, gemfile_lock_path, @revision.commit_hash)
        end

        def gemfile_lock_path
          @gemfile_lock_path ||= @revision.repository.github_ruby_gem_info.gemfile_lock_relative_path
        end
    end
  end
end
