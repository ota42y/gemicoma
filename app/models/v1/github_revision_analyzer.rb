module V1
  class GithubRevisionAnalyzer
    class << self
      # @param [Revision] revision
      def execute(revision)
        return false if revision.done? # other thread done

        ruby_gem_info = revision.repository.github_ruby_gem_info
        analyze_rubygem(revision) if ruby_gem_info

        revision.done!
        true
      end

      private

        # @param [Revision] revision
        def analyze_rubygem(revision)
          gem_data = ::V1::Github::GemData.new(revision)
          gem_data.build!
          gem_data.save!
        end
    end
  end
end
