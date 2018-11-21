class Ruby::VersionsController < ApplicationController
  def index
    latests = Revision::Latest.preload(:repository).left_joins(revision: { revision_dependency_files: :revision_ruby_version })

    ret = latests.map do |latest|
      # @type [Revision::Latest] latest
      repo = latest.repository
      version = latest.revision.revision_dependency_files.first&.revision_ruby_version&.version
      [repo, Gem::Version.new(version)]
    end

    @repo_versions = ret.sort_by(&:last).reverse
  end
end
