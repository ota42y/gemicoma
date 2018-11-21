class Github::UsersController < ApplicationController
  before_action :need_login!

  def show
    @user = ::Github::User.find_by!(name: params[:id])
  end

  private

    def need_login!
      # raise ActiveRecord::RecordNotFound unless logged_in?
    end
end
