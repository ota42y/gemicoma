class V1::DependencyGraph
  CHECK_SIZE = 50

  # @param [Revision::DependencyFile] dependency_file
  # @param [V1::RubygemsSpecification] rubygems_specification
  def initialize(dependency_file, rubygems_specification)
    @dependency_file = dependency_file
    @rubygems_specification = rubygems_specification
  end

  # @return [Array<V1::GemVersionInfo>]
  def dependencies
    @dependencies ||= load_dependencies
  end

  def health_rate
    @health_rate ||= dependencies.count { |d| !d.exist_newer? } / dependencies.count.to_f
  end

  private

    def load_dependencies
      return [] unless @dependency_file

      dependencies = []
      @dependency_file.revision_ruby_specifications.each_slice(CHECK_SIZE) do |specs|
        specs.each { |spec| dependencies << create_gem_version_info(spec) }
      end

      dependencies
    end

    # @param [Revision::Ruby::Specification] spec
    # @@return [V1::GemVersionInfo]
    def create_gem_version_info(spec)
      newest_version = @rubygems_specification.newest_version(spec.name, spec.platform)
      return ::V1::GemVersionInfo.create_unknown(spec) unless newest_version

      ::V1::GemVersionInfo.new(spec, newest_version.to_s)
    end
end
