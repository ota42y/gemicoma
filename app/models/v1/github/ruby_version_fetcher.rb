module V1
  module Github
    class RubyVersionFetcher
      class << self
        # @param [Revision] revision
        def execute(revision, dependency_file)
          self.new(revision, dependency_file).execute!
        end
      end

      # @param [Revision] revision
      def initialize(revision, dependency_file)
        @revision = revision
        @repository = revision.repository
        @dependency_file = dependency_file
      end

      def execute!
        return unless ruby_version_relative_path

        @dependency_file.build_revision_ruby_version(version: ruby_version)
      end

      private

        def ruby_version
          ::V1::GithubRepository.contents_by_string(@repository.github_path, ruby_version_relative_path, @revision.commit_hash)
        end

        def ruby_version_relative_path
          @revision.repository.github_ruby_gem_info.ruby_version_relative_path
        end
    end
  end
end
