class HomeController < ApplicationController
  def index
    @repositories = ::Github::Repository.includes(:github_user).all

    render :index
  end
end
