module V1
  module Github
    class GemData
      # @param [Github::Commit] commit
      def initialize(commit)
        @commit = commit
      end

      def build!
        gemfile_lock

        true
      end

      def gemfile_lock
        @gemfile_lock = ::V1::Dependency::GemLock.create_from_gemfile_lock(gemfile_lock_str)
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
