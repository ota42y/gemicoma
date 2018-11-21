class Ruby::VersionsController < ApplicationController
  def index
    latests = Revision::Latest.preload(:repository).left_joins(revision: { revision_dependency_files: :revision_ruby_version })

    ret = latests.map do |latest|
      # @type [Revision::Latest] latest
      repo = latest.repository
      version = latest.revision.revision_dependency_files.first&.revision_ruby_version&.version
      [repo, version]
    end

    rv = ret.sort do |a, b|
      a_version = parse_ruby_version(a[1])
      b_version = parse_ruby_version(b[1])

      next 1 if b_version.nil?
      next -1 if a_version.nil?

      a_version <=> b_version
    end

    @repo_versions = rv.reverse
  end

  private

    # @return [Gem::Version, nil]
    def parse_ruby_version(version_str)
      return nil unless version_str

      m = version_str.match(/\d+\.\d+\.\d+/)
      return nil unless m

      Gem::Version.new(m[0])
    end
end
