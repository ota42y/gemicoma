module V1
  module Github
    class GemData
      attr_reader :commit, :gemfile_lock, :revision

      # @param [Revision] revision
      def initialize(revision)
        @revision = revision
      end

      def build!
        build_gemfile_lock
        @revision.revision_dependency_files.build(dependency_type: :gemfile_lock, source_filepath: gemfile_lock_path, body: @gemfile_lock_str)

        true
      end

      def save!
        ::Revision::Ruby::Specification.import @gemfile_lock.specifications
        @revision.save!

        true
      end

      private

        def build_gemfile_lock
          return @gemfile_lock if @gemfile_lock

          @gemfile_lock = ::V1::Dependency::GemLock.create_from_gemfile_lock(gemfile_lock_str)
          @gemfile_lock.specifications.each do |s|
            s.revision = revision
          end
        end

        def gemfile_lock_str
          @gemfile_lock_str = open(gemfile_lock_url).read # rubocop:disable Security/Open
        end

        def gemfile_lock_url
          File.join(base_url, gemfile_lock_path)
        end

        def gemfile_lock_path
          File.join(revision.repository.github_ruby_gem_info.gemfile_path, 'Gemfile.lock')
        end

        def base_url
          "https://raw.githubusercontent.com/rails/rails/#{@revision.commit_hash}/"
        end
    end
  end
end
