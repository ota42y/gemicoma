class Ruby::GemsController < ApplicationController
  before_action :need_login!

  def show
    @name = params[:name]
    latests = Revision::Latest.
                preload(:repository).
                left_joins(revision: { revision_dependency_files: :revision_ruby_specifications }).
                where(revision: { revision_dependency_files: { revision_ruby_specifications: { name: @name } } })

    rg = latests.map do |latest|
      # @type [Revision::Latest] latest
      repo = latest.repository
      spec = latest.revision.revision_dependency_files.first.revision_ruby_specifications.find { |r| r.name == @name }
      [repo, spec]
    end

    @repository_gems = rg.to_h
  end

  private

    def need_login!
      # raise ActiveRecord::RecordNotFound unless logged_in?
    end
end
