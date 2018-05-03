
class V1::Dependency::GemLock
  class << self
    # @return [V1::Dependency::GemLock]
    def create_from_gemfile_lock(gemfile_lock_str)
      parser = ::Bundler::LockfileParser.new(gemfile_lock_str)

      specifications = parser.specs.map do |spec|
        ::Revision::Ruby::Specification.new(name: spec.name, version: spec.version, platform: spec.platform)
      end

      self.new(parser, specifications)
    end
  end

  # @return [Array<Revision::Ruby::Specification>] specifications
  attr_accessor :specifications

  # @param [::Bundelr::LockfileParser] parser
  # @param [Array<Revision::Ruby::Specification>] specifications
  def initialize(parser, specifications)
    @parser = parser
    @specifications = specifications
  end

  delegate :sources, to: :@parser
end
