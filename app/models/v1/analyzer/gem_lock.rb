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
        end
      end
    end
  end
end
