class GemVersionInfo
  attr_accessor :new_version
  delegate :name, :version, to: :@gem_spec

  class << self
    def create_unknown(gem_spec)
      self.new(gem_spec, '-')
    end
  end

  def initialize(gem_spec, new_version)
    @gem_spec = gem_spec
    @new_version = new_version
  end
end
