class V1::RubygemAnalyzer
  # @param [Github::Commit] commit
  def initialize(commit)
    @commit = commit
  end

  def save!
    true
  end
end
