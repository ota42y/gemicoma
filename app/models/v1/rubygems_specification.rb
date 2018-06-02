module V1
  class RubygemsSpecification
    def initialize(uri)
      @uri = uri
    end

    # @return Gem::Version
    def newest_version(name, platform)
      specs[platform][name].first
    end

    # Array<Gem::Version> order by version desc
    # @return [Hash{String => Hash{String => Array<Gem::Version>}}]
    def specs
      return @specs if @specs

      @specs = Hash.new { |h, k| h[k] = Hash.new { |gems, name| gems[name] = [] } }

      all_specs.each do |sp|
        name = sp[0]
        version = sp[1]
        platform = sp[2]

        @specs[platform][name] << version
      end

      @specs.each { |_k, pf| pf.each { |_n, gems| gems.sort!.reverse! } }

      @specs
    end

    # <String, Gem::Version, String>
    # @return [Array<Array<String, Gem::Version, String>>]
    def all_specs
      return @all_specs if @all_specs

      remote = Bundler::Source::Rubygems::Remote.new(@uri)
      integration = Bundler::RubygemsIntegration::MoreFuture.new

      source = remote.uri.kind_of?(URI) ? remote.uri : URI.parse(source.to_s)
      @all_specs = integration.fetch_specs(source, remote, 'specs')
    end
  end
end
