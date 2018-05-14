class Admin::BaseController < ApplicationController
  before_action :need_admin!

  private

    def need_admin!
      raise ActiveRecord::RecordNotFound unless logged_in?
      raise ActiveRecord::RecordNotFound unless current_user.admin
    end
end
