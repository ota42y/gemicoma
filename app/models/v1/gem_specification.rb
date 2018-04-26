# copy from Bundler::LazySpecification

class V1::GemSpecification
  attr_accessor :name, :version, :platform

  def initialize(name:, version:, platform:)
    @name = name
    @version = version
    @platform = platform
  end
end
