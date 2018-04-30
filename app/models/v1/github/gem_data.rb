module V1
  module Github
    class GemData
      attr_reader :commit, :gemfile_lock

      # @param [Github::Commit] commit
      def initialize(commit)
        @commit = commit
      end

      def build!
        @gemfile_lock ||= ::V1::Dependency::GemLock.create_from_gemfile_lock(gemfile_lock_str)

        true
      end

      private

        def gemfile_lock_str
          @gemfile_lock_str = open(gemfile_lock_url).read # rubocop:disable Security/Open
        end

        def gemfile_lock_url
          File.join(base_url, @commit.github_repository.github_ruby_gem_info.gemfile_path, 'Gemfile.lock')
        end

        def base_url
          "https://raw.githubusercontent.com/rails/rails/#{@commit.commit_hash}/"
        end
    end
  end
end
