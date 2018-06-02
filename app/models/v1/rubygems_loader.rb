module V1
  class RubygemsLoader
    DEFAULT_RUBYGEM_URI = 'https://rubygems.org/'.freeze

    @use_cache = ::Constants::RUBYGEMS::USE_CACHE
    @cache = {}

    class CacheData
      def initialize(uri, load_at)
        @uri = uri
        @load_at = load_at - ::Constants::RUBYGEMS::CACHE_TIME - 1.second
      end

      def rubygems(use_cache)
        now = Time.current
        if !use_cache || @load_at + ::Constants::RUBYGEMS::CACHE_TIME < now
          @rubygems = V1::RubygemsSpecification.new(@uri)
          @load_at = now
        end

        @rubygems
      end
    end

    class << self
      # @return V1::RubygemsSpecification
      def rubygems_specification(uri)
        @cache[uri] = CacheData.new(uri, Time.current) unless @cache[uri]
        @cache[uri].rubygems(@use_cache)
      end

      # @return V1::RubygemsSpecification
      def default_rubygems
        rubygems_specification(::V1::RubygemsLoader::DEFAULT_RUBYGEM_URI)
      end
    end
  end
end
