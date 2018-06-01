class HomeController < ApplicationController
  def index
    @repositories = ::Github::Repository.includes(:github_user, revisions: { revision_dependency_files: :revision_ruby_specifications }).all

    rubygem_specification = V1::RubygemsSpecification.default_rubygem
    revision_dict = @repositories.map { |r| [r, r.revisions.sort_by(&:created_at).reverse.first] }.to_h

    dependency = revision_dict.map do |repo, r|
      [repo, ::V1::DependencyGraph.new(r.revision_dependency_files.first, rubygem_specification)]
    end
    @repo_to_dependency = dependency.to_h

    render :index
  end
end
