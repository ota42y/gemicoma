
# solv gemfile lock dependency
class V1::Dependency::GemLock
  class << self
    def create_from_gemfile_lock(gemfile_lock_str)
      parser = ::Bundler::LockfileParser.new(gemfile_lock_str)

      specifications = parser.specs.map do |spec|
        ::V1::GemSpecification.new(name: spec.name, version: spec.version, platform: spec.platform)
      end

      self.new(parser, specifications)
    end
  end

  attr_accessor :specifications

  def initialize(parser, specifications)
    @parser = parser
    @specifications = specifications
  end
  delegate :sources, to: :@parser
end
