class ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  skip_before_action :authenticate_admin!, if: :devise_controller?
  skip_before_action :authenticate_admin!, only: [:access_denied]

  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  def authenticate_admin!
    authenticate_user!
    unless current_user.email == "goggin13@gmail.com"
      flash["alert"] = "Please authenticate as an admin."
      redirect_to access_denied_path
    end
  end

  def access_denied
  end

  def cors_set_access_control_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = "POST, PUT, DELETE, GET, OPTIONS"
    headers["Access-Control-Allow-Headers"] = "*"
    headers["Access-Control-Max-Age"] = "1728000"
    headers["Access-Control-Allow-Credentials"] = "true"
  end

  def cors_preflight_check
    return unless request.method == :options
    render :text => "", :content_type => "text/plain"
  end
end
