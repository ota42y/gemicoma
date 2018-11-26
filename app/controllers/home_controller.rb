class HomeController < ApplicationController
  def index
    rubygem_specification = V1::RubygemsLoader.default_rubygems

    latests = ::Revision::Latest.
                     includes(repository: [:github_user, revisions: { revision_dependency_files: :revision_ruby_specifications }]).
                     all

    revision_dict = latests.map { |latest| [latest.repository, latest.revision] }.to_h

    dependency = revision_dict.map do |repo, r|
      [repo, ::V1::DependencyGraph.new(r.revision_dependency_files.first, rubygem_specification)]
    end

    @repo_and_dependency = dependency.sort_by { |data| data[1].health_rate }.reverse
    render :index
  end
end
