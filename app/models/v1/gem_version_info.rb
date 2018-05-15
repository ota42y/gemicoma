module V1
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

    def exist_newer?
      return false if new_version == '-'
      ::Gem::Version.create(new_version) > ::Gem::Version.create(version) # rubocop:disable Rails/SaveBang
    end
  end
end
