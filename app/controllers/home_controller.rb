class HomeController < ApplicationController
  def index
    @repositories = ::Github::Repository.includes(:github_user, revisions: { revision_dependency_files: :revision_ruby_specifications }).all

    revision_dict = @repositories.map { |r| [r, r.revisions.sort_by(&:created_at).reverse.first] }.to_h
    @repo_to_dependency = revision_dict.map { |repo, r| [repo, ::V1::DependencyGraph.new(r.revision_dependency_files.first)] }.to_h

    render :index
  end
end
