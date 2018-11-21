module V1
  module Analyzer
    class GemLock
      class << self
        # @param [Revision::DependencyFile] dependency_file
        def execute(dependency_file)
          dependency_file.revision_ruby_specifications.destroy_all

          parser = ::Bundler::LockfileParser.new(dependency_file.body)
          parser.specs.uniq(&:name).each do |spec|
            dependency_file.revision_ruby_specifications.build(name: spec.name, version: spec.version, platform: spec.platform)
          end

          dependency_file.build_revision_ruby_version(version: parse_ruby_version(parser.ruby_version)) if dependency_file.revision_ruby_version.nil?
        end

        private

        # parser.ruby_version like this ruby 2.5.3p105 so we should 2.5.3
        def parse_ruby_version(parser_ruby_version)
          return nil unless parser_ruby_version

          m = parser_ruby_version.match(/\d+\.\d+\.\d+/)
          return nil unless m

          m[0]
        end
      end
    end
  end
end
