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
          @gemfile_lock_str = open(gemfile_lock_url).read # rubocop:disable Security/Open
        end

        def gemfile_lock_url
          File.join(base_url, gemfile_lock_path)
        end

        def gemfile_lock_path
          File.join(@revision.repository.github_ruby_gem_info.gemfile_path, 'Gemfile.lock')
        end

        def base_url
          File.join(github_path, @revision.commit_hash)
        end

        def github_path
          File.join('https://raw.githubusercontent.com', @repository.github_path)
        end
    end
  end
end
