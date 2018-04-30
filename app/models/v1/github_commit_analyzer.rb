module V1
  class GithubCommitAnalyzer
    class << self
      # @param [Github::Commit] commit
      def execute(commit)
        return false if commit.done? # other thread done

        ruby_gem_info = commit.github_repository.github_ruby_gem_info
        analyze_rubygem(commit) if ruby_gem_info

        commit.done!
        true
      end

      private

        # @param [Github::Commit] commit
        def analyze_rubygem(commit)
          gem_data = ::V1::Github::GemData.new(commit)
          ::V1::RubygemAnalyzer.new(gem_data).save!
        end
    end
  end
end
