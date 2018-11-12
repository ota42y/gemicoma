module V1
  module Analyzer
    class Revision
      class << self
        # @param [Revision] revision
        def execute(revision)
          return false unless revision.downloaded?

          revision.revision_dependency_files.each do |dependency|
            # @type [Revision::DependencyFile] dependency

            ActiveRecord::Base.transaction do
              ::V1::Analyzer::GemLock.execute(dependency) if dependency.gemfile_lock?
              dependency.save!
            end
          end

          ActiveRecord::Base.transaction do
            revision.done!
            revision.update_revision
          end

          true
        end
      end
    end
  end
end
