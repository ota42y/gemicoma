class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  rescue_from Exception do |e|
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    if Rails.env.production?
      render status: 500, json: { errors: [{ message: 'Internal server error' }] }
    else
      Rails.logger.fatal(e.backtrace[0..5].join("\n"))
      render status: 500, json: { errors: [{ message: "#{e.message}: #{e.backtrace}" }] }
    end
  end

  rescue_from ActionController::BadRequest do |e|
    render status: 400, json: { errors: [{ message: e.message }] }
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: 404, json: { errors: [{ message: e.message }] }
  end

  private

    # @return [User]
    def current_user
      return unless session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end

    def logged_in?
      !!session[:user_id]
    end

    def authenticate
      return if logged_in?
      redirect_to root_path, alert: 'ログインしてください'
    end
end
