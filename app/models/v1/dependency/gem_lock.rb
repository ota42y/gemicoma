
# solv gemfile lock dependency
class V1::Dependency::GemLock
  def initialize(gemfile_lock_str)
    @parser = ::Bundler::LockfileParser.new(gemfile_lock_str)
  end
  delegate :specs, :sources, to: :@parser
end
