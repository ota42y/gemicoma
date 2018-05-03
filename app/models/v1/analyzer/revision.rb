module V1
  module Analyzer
    class Revision
      class << self
        # @param [Revision] revision
        def execute(revision)
          return false unless revision.downloaded?

          revision.revision_dependency_files.each do |dependency|
            # @type [Revision::DependencyFile] dependency
            ::V1::Analyzer::GemLock.execute(dependency) if dependency.gemfile_lock?
            dependency.save!
          end

          revision.done!

          true
        end
      end
    end
  end
end
