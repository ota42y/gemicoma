class V1::RubygemAnalyzer
  # @param [V1::Dependency::GemLock] gem_lock
  def initialize(gem_lock)
    @gem_lock = gem_lock
  end

  def save!
    true
  end
end
