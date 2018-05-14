class V1::DependencyGraph
  CHECK_SIZE = 50

  # @param [Revision::DependencyFile] dependency_file
  def initialize(dependency_file)
    @dependency_file = dependency_file
  end

  # @return [Array<V1::GemVersionInfo>]
  def dependencies
    @dependencies ||= load_dependencies
  end

  private

    def load_dependencies
      return [] unless @dependency_file

      dependencies = []
      @dependency_file.revision_ruby_specifications.each_slice(CHECK_SIZE) do |specs|
        dump_gems = ::Dump::Rubygems::Rubygem.
                      where(name: specs.map(&:name)).
                      includes(:dump_rubygems_versions).
                      map { |g| [g.name, g] }.
                      to_h

        specs.each do |spec|
          dependencies << create_gem_version_info(spec, dump_gems[spec.name])
        end
      end

      dependencies
    end

    def create_gem_version_info(spec, gem)
      return ::V1::GemVersionInfo.create_unknown(spec) unless gem
      platform_versions = gem.dump_rubygems_versions.select { |v| v.platform == spec.platform }

      newest_version = platform_versions.map { |v| ::Gem::Version.create(v.number) }.sort.last
      return ::V1::GemVersionInfo.create_unknown(spec) unless newest_version

      ::V1::GemVersionInfo.new(spec, newest_version.to_s)
    end
end
