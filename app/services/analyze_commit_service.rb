class AnalyzeCommitService
  class << self
    # @param [Github::Commit] commit
    def execute(commit)
      return false if commit.done? # other thread done

      ruby_gem_info = commit.github_repository.github_ruby_gem_info
      ::V1::RubygemAnalyzer.new(commit).save! if ruby_gem_info

      commit.done!
      true
    end
  end
end
